class ImportCableRunsController < ActionController::Base
  def create
    importer = ImportCableRun.new(
      workbookFile: params[:workbookFile],
      sheet: params[:sheet],
      building_id: params[:building_id]
    )

    respond_to do |format|
      format.json { render json: { success: importer.save } }
    end
  end
end
