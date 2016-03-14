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

  validates :sheet_id, presence: true
  validates :network_template_id, presence: true

  def NetworkGraph.latest_for(building)

  	sheets_with_graphs = building.sheets.which_have_graphs
  	return nil if sheets_with_graphs.empty?

  	latest_sheet = sheets_with_graphs.last  	
  	latest_graph = latest_sheet.network_graphs.last
  end

  #TODO: remove when REAL ActiveRecord Nodes is implemented
  def nodes 
    TempNodes.data
  end

  #TODO: remove when REAL ActiveRecord Edges is implemented
  def edges
    TempEdges.data
  end
end
