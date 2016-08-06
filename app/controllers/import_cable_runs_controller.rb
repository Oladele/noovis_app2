class ImportCableRunsController < ApplicationController
  before_action :authenticate_user!
  before_action :admin_only

  def create
    @importer = ImportCableRun.new(
      file: params[:file],
      sheet: params[:sheet],
      building_id: params[:building_id]
    )

    @importer.process! if @importer.status == :created

    render status: @importer.status, json: { message: @importer.message }
  end
end
