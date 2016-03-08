class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.references :network_graph, index: true, foreign_key: true
      t.references :node_type, index: true, foreign_key: true
      t.string :node_value
      t.decimal :x_pos, precision: 8, scale: 2
      t.decimal :y_pos, precision: 8, scale: 2
      t.integer :node_level

      t.timestamps null: false
    end
  end
end
