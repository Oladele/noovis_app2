class AddColumnsValueToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :value, :string
  end
end
