class RemoveSessionKeyColumn < ActiveRecord::Migration
  def up
    remove_column :drones, :session_key
  end

  def down
    add_column :drones, :session_key, :string
  end
end
