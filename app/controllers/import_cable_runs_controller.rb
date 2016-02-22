class ImportCableRunsController < ActionController::Base
  def create
    @importer = ImportCableRun.new(
      workbookFile: params[:workbookFile],
      sheet: params[:sheet],
      building_id: params[:building_id]
    )

    render status: @importer.status, json: { message: @importer.message }
  end
end
