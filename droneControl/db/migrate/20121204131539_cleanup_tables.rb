class CleanupTables < ActiveRecord::Migration
  def up
    drop_table "actions"
    drop_table "flight_action_relationships"
    drop_table "instructions"
    drop_table "drones_privileges"
  end

  def down
    create_table "actions" do |t|
      t.integer  "duration"
      t.integer  "flight_action_relationship_id"
      t.integer  "instruction_id"
      t.datetime "created_at",                    :null => false
      t.datetime "updated_at",                    :null => false
    end

    add_index "actions", ["flight_action_relationship_id"], :name => "index_actions_on_flight_action_relationship_id"
    add_index "actions", ["instruction_id"], :name => "index_actions_on_instruction_id"

    create_table "flight_action_relationships" do |t|
      t.integer  "rank"
      t.integer  "flight_plan_id"
      t.datetime "created_at",     :null => false
      t.datetime "updated_at",     :null => false
    end

    add_index "flight_action_relationships", ["flight_plan_id"], :name => "index_flight_action_relationships_on_flight_plan_id"

    create_table "instructions" do |t|
      t.string   "AT_command"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "drones_privileges", :id => false do |t|
      t.integer "drone_id"
      t.integer "privilege_id"
    end

    add_index "drones_privileges", ["drone_id", "privilege_id"], :name => "index_drones_privileges_on_drone_id_and_privilege_id"
  end
end
