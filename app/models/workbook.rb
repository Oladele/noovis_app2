# == Schema Information
#
# Table name: workbooks
#
#  id              :integer          not null, primary key
#  name            :string
#  network_site_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Workbook < ActiveRecord::Base
  belongs_to :network_site
  has_one :company, through: :network_site
  has_many :sheets, dependent: :destroy
  has_many :network_graphs, through: :sheets
  
  validates :name, presence: true
  validates :network_site_id, presence: true

  def get_nodes    
    nodes = network_graphs.map{|ng| ng.nodes}.flatten 1  
  end
end
