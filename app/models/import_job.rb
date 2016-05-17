class ImportJob < ActiveRecord::Base
  belongs_to :building

  validates :building_id, :filename, :sheet_name, presence: true
  validates :status, inclusion: %w[processing error completed]

  has_attached_file :spreadsheet, path: ":custom_path"
  validates_attachment_file_name :spreadsheet, :matches => [/csv\Z/, /xlsx?\Z/]

  Paperclip.interpolates :custom_path do |attachment, style|
    import_job = attachment.instance
    building = import_job.building
    network_site = building.network_site

    # import_jobs/company/:company_id/network_site/:network_site_id/building/:building_id/:import_job_id-filename
    "import_jobs/company/#{network_site.company_id}/network_site/#{network_site.id}/building/#{building.id}/#{import_job.id}-#{import_job.filename}"
  end
end
