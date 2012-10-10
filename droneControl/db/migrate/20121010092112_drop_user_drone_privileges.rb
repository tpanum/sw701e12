class DropUserDronePrivileges < ActiveRecord::Migration
  def up
  	if ActiveRecord::Base.connection.table_exists? "user_drone_privileges"
  		drop_table :user_drone_privileges
  	end
  end

  def down
  end
end
