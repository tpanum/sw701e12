class CreateFlightActionRelationships < ActiveRecord::Migration
  def change
    create_table :flight_action_relationships do |t|
      t.integer "rank"
      t.references :flight_plans
      t.timestamps
    end
  end
end
