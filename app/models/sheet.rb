class Sheet < ActiveRecord::Base
  belongs_to :workbook
  belongs_to :building
  has_many :cable_runs

  validates :name, presence: true
  validates :workbook_id, presence: true
  validates :building_id, presence: true
end
