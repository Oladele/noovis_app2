class AddFieldsToNodes < ActiveRecord::Migration
  def change
    add_reference :nodes, :parent, index: true
    add_reference :nodes, :cable_run, index: true
  end
end
