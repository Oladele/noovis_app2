class Workbook < ActiveRecord::Base
  belongs_to :network_site
  has_many :sheets
  
  validates :name, presence: true
  validates :network_site_id, presence: true
end
