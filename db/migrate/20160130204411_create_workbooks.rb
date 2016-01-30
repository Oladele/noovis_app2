class CreateWorkbooks < ActiveRecord::Migration
  def change
    create_table :workbooks do |t|
      t.string :name
      t.references :network_site, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
