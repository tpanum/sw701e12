class CreateFlightPlans < ActiveRecord::Migration
  def change
    create_table :flight_plans do |t|
      t.string "name"
      t.references :drones
      t.timestamps
    end

    change_table :flight_plans do |t|
      t.index :drones_id
    end
  end
end
