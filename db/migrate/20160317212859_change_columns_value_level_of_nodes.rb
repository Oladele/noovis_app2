class ChangeColumnsValueLevelOfNodes < ActiveRecord::Migration
    def change
	  change_table :nodes do |t|
	  	t.rename :value, :label
	  	t.string :level
	  end
  end
end
