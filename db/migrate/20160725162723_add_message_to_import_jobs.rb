class AddMessageToImportJobs < ActiveRecord::Migration
  def change
    add_column :import_jobs, :message, :string
  end
end
