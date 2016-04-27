class ImportCableRunsController < ActionController::Base  # TODO: Shouldn't this be behind auth?
  def create
    @importer = ImportCableRun.new(
      file: params[:file],
      sheet: params[:sheet],
      building_id: params[:building_id]
    )

    @importer.process! if @importer.status == :created

    render status: @importer.status, json: { message: @importer.message }
    #render status: :created, json: { message: "Successfully created cable runs" }
  end
end
