class ChangeSessionKeysToSession < ActiveRecord::Migration
  def change
    rename_table :session_keys, :sessions
    add_column :sessions, :user_id, :int, :after => :drone_id
    add_index :sessions, :drone_id
  end
end
