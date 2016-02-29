class ImportCableRunsController < ActionController::Base
  def create
    @importer = ImportCableRun.new(
      workbookFile: params[:file],
      sheet: params[:sheet],
      building_id: params[:building_id]
    )

    #render status: @importer.status, json: { message: @importer.message }
    render status: :created, json: { message: "Successfully created cable runs" }
  end
end
