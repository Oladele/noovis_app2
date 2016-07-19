class RemoveFieldsFromNodes < ActiveRecord::Migration
  def change
    remove_reference :nodes, :node_type, index: true, foreign_key: true
    remove_column :nodes, :x_pos, :decimal
    remove_column :nodes, :y_pos, :decimal
  end
end
