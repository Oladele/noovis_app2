class Sheet < ActiveRecord::Base
  belongs_to :workbook
  belongs_to :building

  validates :name, presence: true
  validates :workbook_id, presence: true
  validates :building_id, presence: true
end
