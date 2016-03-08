class RenameFieldInNodeType < ActiveRecord::Migration
  def change
    rename_column :node_types, :url, :picture
  end
end
