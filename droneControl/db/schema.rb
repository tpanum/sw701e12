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

ActiveRecord::Schema.define(:version => 20120920130001) do

  create_table "actions", :force => true do |t|
    t.integer  "duration"
    t.integer  "flight_action_relationships_id"
    t.integer  "instructions_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "actions", ["flight_action_relationships_id"], :name => "index_actions_on_flight_action_relationships_id"
  add_index "actions", ["instructions_id"], :name => "index_actions_on_instructions_id"

  create_table "drone_roles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "drones", :force => true do |t|
    t.string   "ip"
    t.string   "location"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "flight_action_relationships", :force => true do |t|
    t.integer  "rank"
    t.integer  "flight_plans_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "flight_plans", :force => true do |t|
    t.string   "name"
    t.integer  "drones_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "flight_plans", ["drones_id"], :name => "index_flight_plans_on_drones_id"

  create_table "instructions", :force => true do |t|
    t.string   "AT_command"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "privileges", :force => true do |t|
    t.string   "description"
    t.integer  "roles_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "privileges", ["roles_id"], :name => "index_privileges_on_roles_id"

  create_table "roles", :force => true do |t|
    t.string   "title"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_drone_privileges", :force => true do |t|
    t.integer  "users_id"
    t.integer  "drones_id"
    t.integer  "drone_roles_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "user_drone_privileges", ["drone_roles_id"], :name => "index_user_drone_privileges_on_drone_roles_id"
  add_index "user_drone_privileges", ["drones_id"], :name => "index_user_drone_privileges_on_drones_id"
  add_index "user_drone_privileges", ["users_id"], :name => "index_user_drone_privileges_on_users_id"

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email",           :default => "", :null => false
    t.string   "salt"
    t.string   "hashed_password"
    t.string   "password"
    t.integer  "roles_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "users", ["roles_id"], :name => "index_users_on_roles_id"

end
