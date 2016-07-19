class AddColumnsLevelOthersToEdges < ActiveRecord::Migration
  def change
    add_column :edges, :level, :integer
    add_column :edges, :to, :integer
    add_column :edges, :from, :integer
  end
end
