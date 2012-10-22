class RenameIdColumnsInFlightActionRelationships < ActiveRecord::Migration
  def change
    rename_column :flight_action_relationships, :flight_plans_id, :flight_plan_id
    add_index :flight_action_relationships, :flight_plan_id
  end
end
