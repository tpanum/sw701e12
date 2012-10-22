# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121022131609) do

  create_table "actions", :force => true do |t|
    t.integer  "duration"
    t.integer  "flight_action_relationships_id"
    t.integer  "instructions_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "actions", ["flight_action_relationships_id"], :name => "index_actions_on_flight_action_relationships_id"
  add_index "actions", ["instructions_id"], :name => "index_actions_on_instructions_id"

  create_table "drones", :force => true do |t|
    t.string   "ip"
    t.string   "location"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "session_key"
  end

  create_table "drones_privileges", :id => false, :force => true do |t|
    t.integer "drone_id"
    t.integer "privilege_id"
  end

  add_index "drones_privileges", ["drone_id", "privilege_id"], :name => "index_drones_privileges_on_drone_id_and_privilege_id"

  create_table "flight_action_relationships", :force => true do |t|
    t.integer  "rank"
    t.integer  "flight_plans_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "flight_plans", :force => true do |t|
    t.string   "name"
    t.integer  "drone_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "flight_plans", ["drone_id"], :name => "index_flight_plans_on_drone_id"

  create_table "instructions", :force => true do |t|
    t.string   "AT_command"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "privileges", :force => true do |t|
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "privileges_roles", :id => false, :force => true do |t|
    t.integer "privilege_id"
    t.integer "role_id"
  end

  add_index "privileges_roles", ["privilege_id", "role_id"], :name => "index_privileges_roles_on_privilege_id_and_role_id"

  create_table "roles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id"

  create_table "user_privileges", :force => true do |t|
    t.integer  "user_id"
    t.integer  "privilege_id"
    t.integer  "flag",         :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "user_privileges", ["user_id", "privilege_id"], :name => "index_user_privileges_on_user_id_and_privilege_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",           :default => "", :null => false
    t.string   "salt"
    t.string   "hashed_password"
    t.string   "password"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

end
