# == Schema Information
#
# Table name: network_graphs
#
#  id                  :integer          not null, primary key
#  sheet_id            :integer
#  network_template_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class NetworkGraph < ActiveRecord::Base
  belongs_to :sheet
  belongs_to :network_template
  has_many :nodes, dependent: :destroy
  has_many :edges, dependent: :destroy

  validates :sheet_id, presence: true
  validates :network_template_id, presence: true

  attr_reader :nodes_in_memory

  def NetworkGraph.latest_for(building)

  	sheets_with_graphs = building.sheets.which_have_graphs
  	return nil if sheets_with_graphs.empty?

  	latest_sheet = sheets_with_graphs.last  	
  	latest_graph = latest_sheet.network_graphs.last
  end

  def make_nodes_edges
    @cable_runs = sheet.cable_runs
    @workbook = sheet.workbook

    @node_tree_types = 
      [
        "olt_chassis",
        "pon_card",
        "pon_port",
        "building",
        "fdh",
        "splitter",
        "rdt",
        "room",
        "ont_sn",
        "ont_ge_1_mac",
        "ont_ge_2_mac",
        "ont_ge_3_mac",
        "ont_ge_4_mac",
      ]

    # used for handling special case of ont_devices/macs
    # which are all on same level
    @ont_node_level = @node_tree_types.index "ont_sn"
    
    @nodes_in_memory = []
    @edges_in_memory = []

    @uniq_olt_chassis_values = []
    @node_types_whose_values_should_include_parent_value = ["pon_port"]

    set_nodes_edges
  end

  private

    def fill_blanks_and_sort(rows)

      # prep for sort by filling blanks
      rows.each do |row|
        row.each do |key,value|
          if value == nil or value == ""
            row[key] = "blank"+" "+key.to_s
          end
          if value.to_s.strip.upcase == "N/A"
            row[key] = "N/A"+" "+key.to_s
          end
        end
      end

      # sort
      rows = rows.sort_by! do |row|
        ord = []
        @node_tree_types.each do |type|
          ord << row[type]
        end
        ord
      end
    end

    def set_nodes_edges
      @rows = @cable_runs.as_json

      if @rows == nil or @rows.length == 0
        #do nothing
      else
        fill_blanks_and_sort @rows 
        
        @rows.each_with_index do |row, row_index|
          node_level = 0
          make_new_nodes_edges(node_level, row, nil)
        end

      end
    end
    

    def make_new_nodes_edges(node_level, row, parent)
      node_type = @node_tree_types[node_level]
      value = row[node_type]
      cable_run_id = row["id"]

      #special case ont descendants (ports)
      # their node_levels are all same
      if node_level > @ont_node_level
        level = @ont_node_level + 1
      else
        level = node_level
      end

      existing_node = check_last_created_node(node_level, value, parent)
      if existing_node
        # set node to be used as parent node for next iteration
        node = existing_node
      else
        # create node
        node_params = {
          node_value: value, 
          node_type: node_type, 
          node_level: level,
          cable_run_id: cable_run_id,
          parent: parent
        }

        node = create_node node_params, row
      end

      #recursively create children
      if node_level < @node_tree_types.size - 1
        next_level = node_level+1
        if node_level > @ont_node_level
          #special case ONT descendants are ALL same level
          parent_of_next_node = node.parent
          make_new_nodes_edges(next_level, row, parent_of_next_node)
        else
          #this node is parent of next level
          parent_of_next_node = node
          make_new_nodes_edges(next_level, row, parent_of_next_node)
        end
      end
    end

    def create_node(node_params, row)

      
      # node = nodes.create node_params
      if node_params[:node_type] == "olt_chassis"
        olt = get_olt_chassis_if_it_exists(node_params[:node_value])
        if olt
          node = olt
        else
          @uniq_olt_chassis_values.push(node_params[:node_value])
          node = nodes.create node_params
        end
      else
        node = nodes.create node_params
      end


      if node.node_level == @ont_node_level
        row["ont_node_id"] = node.id
      end
      if node.node_level > @ont_node_level
        if node.is_blank or node.is_na
          node.delete #remove from db before continuing
          return node
        end
      end

      if @node_types_whose_values_should_include_parent_value.include? node.node_type
        node.node_value = "#{node.parent.node_value}/#{node.node_value}"
      end


      @nodes_in_memory << node

      edges = create_edges node
      
      return node 
    end

    # performnce optimization required here:
    # raised unicorn timeout to obscene 90s because of this:
    def last_created_node(level, value = nil)
      reverse_nodes = @nodes_in_memory.reverse
      if value
        node = reverse_nodes.find do |node|
          node.node_level == level && node.node_value == value
        end
      else
        node = reverse_nodes.find do |node|
          node.node_level == level
        end
      end
      node
    end

    def check_last_created_node(level, value, parent)
      node = last_created_node(level, value)
      if node
        node if node.node_value == value && node.parent == parent
      else
        nil
      end
    end

    def get_olt_chassis_if_it_exists(olt_chassis_value)
      if @uniq_olt_chassis_values.include? olt_chassis_value
        nodes = @nodes_in_memory
      else
        @uniq_olt_chassis_values.push(olt_chassis_value)
        nodes = @workbook.get_nodes
      end
      olts = nodes.select{|node| node.node_value == olt_chassis_value}
      olt = olts.last
    end

    def create_edges(node)
      parent_node = node.parent
      node_edges = []
      if parent_node
        to_id = parent_node.id
        edge_params = {
          to_node_id: to_id,
          from_node_id: node.id,
          edge_level: node.node_level,
          network_graph_id: id
        }
        edge = edges.create edge_params
        node_edges << edge
        @edges_in_memory << edge
    
        node_edges
      end
    end


end
