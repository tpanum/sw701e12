class CreateFlightPlans < ActiveRecord::Migration
  def change
    create_table :flight_plans do |t|
      t.string "name"
      t.timestamps
    end
  end
end
