class CreateSheets < ActiveRecord::Migration
  def change
    create_table :sheets do |t|
      t.string :name
      t.references :workbook, index: true, foreign_key: true
      t.references :building, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
