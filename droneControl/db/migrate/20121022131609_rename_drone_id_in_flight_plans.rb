class RenameDroneIdInFlightPlans < ActiveRecord::Migration
  def change
    rename_column :flight_plans, :drones_id, :drone_id
    rename_index :flight_plans, :drones_id, :drone_id
  end
end
