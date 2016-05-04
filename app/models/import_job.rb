class ImportJob < ActiveRecord::Base
  belongs_to :building

  validates :building_id, :filename, :sheet_name, presence: true
  validates :status, inclusion: %w[processing error completed]

  has_attached_file :spreadsheet
  validates_attachment_file_name :spreadsheet, :matches => [/csv\Z/, /xlsx?\Z/]
end
