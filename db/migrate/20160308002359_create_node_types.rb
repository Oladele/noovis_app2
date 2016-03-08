class CreateNodeTypes < ActiveRecord::Migration
  def change
    create_table :node_types do |t|
      t.string :name
      t.string :url

      t.timestamps null: false
    end
  end
end
