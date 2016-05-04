class CreateImportJobs < ActiveRecord::Migration
  def change
    create_table :import_jobs do |t|
      t.references :building
      t.string :status
      t.string :filename
      t.string :sheet_name

      t.timestamps null: false
    end

    add_attachment :import_jobs, :spreadsheet
  end
end
