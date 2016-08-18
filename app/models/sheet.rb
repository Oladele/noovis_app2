# == Schema Information
#
# Table name: sheets
#
#  id          :integer          not null, primary key
#  name        :string
#  workbook_id :integer
#  building_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Sheet < ActiveRecord::Base
  belongs_to :workbook
  belongs_to :building, touch: true
  has_one :company, through: :building
  has_many :cable_runs, dependent: :destroy
  has_many :network_graphs, dependent: :destroy

  validates :name, presence: true
  validates :workbook_id, presence: true
  validates :building_id, presence: true

  def Sheet.which_have_graphs
  	select {|sheet| !sheet.network_graphs.empty?}
  end

  def record_count
    self.cable_runs.count
  end
end
