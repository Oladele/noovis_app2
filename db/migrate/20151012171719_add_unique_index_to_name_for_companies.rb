class AddUniqueIndexToNameForCompanies < ActiveRecord::Migration
  change_table :companies do |t|
  	t.change :name, :string, null: false
  	t.index :name, unique: true
  end
end
