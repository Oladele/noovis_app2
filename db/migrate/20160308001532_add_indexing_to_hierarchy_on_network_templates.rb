class AddIndexingToHierarchyOnNetworkTemplates < ActiveRecord::Migration
  def change
    add_index :network_templates, :hierarchy, using: :gin
  end
end
