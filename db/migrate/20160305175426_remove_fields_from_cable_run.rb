class RemoveFieldsFromCableRun < ActiveRecord::Migration
  def change
    remove_column :cable_runs, :lgx_port, :string
    remove_column :cable_runs, :vam_smp, :string
    remove_column :cable_runs, :fsan_sn, :string
    remove_column :cable_runs, :test_1310, :string
    remove_column :cable_runs, :test_1550, :string
  end
end
