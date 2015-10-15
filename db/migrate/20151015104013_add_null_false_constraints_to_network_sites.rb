class AddNullFalseConstraintsToNetworkSites < ActiveRecord::Migration
  change_table :network_sites do |t|
  	t.change :name, :string, null: false
  	t.change :company_id, :integer, null: false
  end
end
