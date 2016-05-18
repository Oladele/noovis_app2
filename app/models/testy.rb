class Testy
  def self.import2(template, values)
    graph = { sites: [] }

    values.each do |row|
      previous = graph  # Start at the top

      row.each_with_index do |col, index|
        col = "N/A" if col.nil?

        type = template[index][:type]
        collection = template[index][:collection]

        # Do we have this node yet?
        object = previous[type].select { |object| object[:value] == col }.first

        # If not, make it.
        if object.nil?
          object = { value: col.is_a?(Float) ? col.to_i.to_s : col }  # If it's a number, `1` is sometimes read in as `1.0`
          object[collection] = [] if collection.present?  # Could be end of graph

          previous[type] << object
        end

        # Set the current place in the nested structure for the next iteration
        previous = object
      end
    end

    graph
  end

  def self.template_order(headers, values)
    order_index = 0
    fail_safe = 0

    ordered = []

    while order_index < headers.count
      values.each_with_index do |value, index|
        if headers[order_index] == value
          ordered << index
          order_index += 1
          fail_safe = 0
        end
      end

      fail_safe += 1
      return 'ordering error' if fail_safe > 100
    end

    ordered
  end

  def self.reorder_sheet(order, values)
    ordered = []

    values.each do |row|
      ordered << order.collect { |index| row[index] }
    end

    ordered
  end

  def self.read_spreadsheet(file, sheet_name)
    found_headers = false
    data = []

    spreadsheet = Roo::Spreadsheet.open(file, extension: :xls)

    spreadsheet.sheet(sheet_name).each do |row|
      # TODO: might want to check inclusion of all header values and not just if the first one matches
      found_headers = true if row[0] == "Site"

      if found_headers == true
        data << []
        row.each do |col|
          data.last << col
        end
      end
    end

    found_headers ? data : 'read spreadsheet error'
  end

  def self.do_it(network_template, file, sheet_name)
    # 1
    spreadsheet_data = read_spreadsheet(file, sheet_name)

    #@node_tree_types =
      #[
        #"olt_chassis",
        #"pon_card",
        #"pon_port",
        #"building",
        #"fdh",
        #"splitter",
        #"rdt",
        #"room",
        #"ont_sn",
        #"ont_ge_1_mac",
        #"ont_ge_2_mac",
        #"ont_ge_3_mac",
        #"ont_ge_4_mac",
      #]


    # 2
    template_order = self.template_order(network_template, spreadsheet_data[0])

    # 3
    values = self.reorder_sheet(template_order, spreadsheet_data)

    template = self.build_template_from_network_template(network_template)

    # 4
    self.import2(template, values[1..-1])

    # 5
  end

  def self.build_template_from_network_template(network_template)
    # Duplicating some info here, might be a cleaner way to structure this.
    template = []

    network_template.each_with_index do |value, index|
      # Look ahead to grab the collection name
      collection_name = network_template[index + 1]

      object = { type: self.format(value) }
      object[:collection] = self.format(collection_name) if collection_name.present?

      template << object
    end

    template
  end

  def self.format(value)
    value.downcase.pluralize.gsub(' ', '_').to_sym
  end
end
