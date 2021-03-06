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

ActiveRecord::Schema.define(:version => 20121212135403) do

  create_table "affiliate_privileges", :force => true do |t|
    t.integer  "privilege_id"
    t.integer  "affiliate"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "affiliate_privileges_roles", :id => false, :force => true do |t|
    t.integer "affiliate_privilege_id"
    t.integer "role_id"
  end

  add_index "affiliate_privileges_roles", ["affiliate_privilege_id"], :name => "index_affiliate_privileges_roles_on_affiliate_privilege_id"
  add_index "affiliate_privileges_roles", ["role_id"], :name => "index_affiliate_privileges_roles_on_role_id"

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "companies_users", :id => false, :force => true do |t|
    t.integer "company_id"
    t.integer "user_id"
  end

  add_index "companies_users", ["company_id", "user_id"], :name => "index_companies_users_on_company_id_and_user_id"

  create_table "company_roles", :force => true do |t|
    t.integer  "company_id"
    t.integer  "role_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "company_roles", ["company_id", "role_id"], :name => "index_company_roles_on_company_id_and_role_id"

  create_table "drones", :force => true do |t|
    t.string   "ip"
    t.string   "location"
    t.string   "name"
    t.text     "description"
    t.integer  "company_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "privileges", :force => true do |t|
    t.string   "identifier"
    t.text     "description"
    t.integer  "instance_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "privileges", ["identifier"], :name => "index_privileges_on_identifier"

  create_table "roles", :force => true do |t|
    t.string   "title"
    t.integer  "level_type", :default => 2
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["user_id", "role_id"], :name => "index_roles_users_on_user_id_and_role_id"

  create_table "session_key_tasks", :force => true do |t|
    t.integer "drone_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_key"
    t.integer  "drone_id"
    t.integer  "user_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "sessions", ["drone_id"], :name => "index_sessions_on_drone_id"

  create_table "user_privileges", :force => true do |t|
    t.integer  "user_id"
    t.integer  "affiliate_privilege_id"
    t.integer  "flag",                   :null => false
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "user_privileges", ["user_id", "affiliate_privilege_id"], :name => "index_user_privileges_on_user_id_and_affiliate_privilege_id"

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
