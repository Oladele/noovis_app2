class NetworkGraph < ActiveRecord::Base
  belongs_to :sheet
  belongs_to :network_template

  validates :sheet_id, presence: true
  validates :network_template_id, presence: true
end
