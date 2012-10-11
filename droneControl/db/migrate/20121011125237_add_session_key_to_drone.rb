class AddSessionKeyToDrone < ActiveRecord::Migration
  def change
    add_column(:drones, "session_key", :string)
  end
end
