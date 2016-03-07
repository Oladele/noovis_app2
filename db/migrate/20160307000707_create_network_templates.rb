class CreateNetworkTemplates < ActiveRecord::Migration
  def change
    create_table :network_templates do |t|
      t.string :name
      t.string :description
      t.string :hierarchy, default: [], array: true

      t.timestamps null: false
    end
  end
end
