class ImportCableRunsController < ActionController::Base
  def create
    importer = ImportCableRun.new(workbook: params[:workbookFile], sheet: params[:sheet])

    respond_to do |format|
      format.json { render json: { success: importer.save } }
    end
  end

  private

  def import_params
    params.require(import_cable_run).permit(
      :workbook,
      :sheet,
      :building_id
    )
  end
end
