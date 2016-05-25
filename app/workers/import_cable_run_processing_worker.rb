class ImportCableRunProcessingWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :imports, :retry => false, :backtrace => true

  def perform(import_job_id)
    begin
      import_job = ImportJob.find(import_job_id)

      file = AwsService.get_file(import_job.spreadsheet.path)

      begin
        import_cable_run = ImportCableRun.new(
          file: file,
          sheet: import_job.sheet_name,
          building_id: import_job.building_id,
          filename: import_job.filename
        )

        graph = SpreadsheetImporter.import(SpreadsheetImporter::NETWORK_TEMPLATE, file, import_job.sheet_name)
        TestNetworkGraph.create!(building_id: import_job.building_id, graph: graph)

        #import_cable_run.save_workbook
        import_job.update_attribute(:status, 'completed')
      ensure
        File.delete(file)
      end
    rescue => e
      Logger.new(STDOUT).error "Exception importing cable run: #{e}"
      import_job.update_attribute(:status, 'error')
    end
  end
end
