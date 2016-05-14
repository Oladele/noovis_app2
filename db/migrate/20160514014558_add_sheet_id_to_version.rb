class AddSheetIdToVersion < ActiveRecord::Migration
  def change
    add_column :versions, :sheet_id, :integer
  end
end
