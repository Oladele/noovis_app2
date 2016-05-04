class ImportCableRunProcessingWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :imports, :retry => false, :backtrace => true

  def perform(import_job_id)
    begin
      import_job = ImportJob.find(import_job_id)

      file = File.new(import_job.spreadsheet.path)

      import_cable_run = ImportCableRun.new(
        file: file,
        sheet: import_job.sheet_name,
        building_id: import_job.building_id,
        filename: import_job.filename
      )

      import_cable_run.save_workbook
      import_job.update_attribute(:status, 'completed')
    rescue => e
      # TODO: log this?
      import_job.update_attribute(:status, 'error')
    end
  end
end
