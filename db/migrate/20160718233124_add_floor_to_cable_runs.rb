class AddFloorToCableRuns < ActiveRecord::Migration
  def change
    add_column :cable_runs, :floor, :string
  end
end
