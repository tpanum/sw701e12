class RenameDroneIdInFlightPlans < ActiveRecord::Migration
  def change
    rename_column :flight_plans, :drones_id, :drone_id
    rename_index :flight_plans, 'index_flight_plans_on_drones_id', 'index_flight_plans_on_drone_id'
  end
end
