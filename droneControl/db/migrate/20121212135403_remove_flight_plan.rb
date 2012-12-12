class RemoveFlightPlan < ActiveRecord::Migration
  def up
    drop_table :flight_plans
  end

  def down
    create_table :flight_plans do |t|
      t.string   "name"
      t.integer  "drone_id"
      t.timestamps
    end

    add_index "flight_plans", ["drone_id"], :name => "index_flight_plans_on_drone_id"
  end
end
