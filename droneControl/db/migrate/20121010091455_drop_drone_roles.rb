class DropDroneRoles < ActiveRecord::Migration
  def up
  	if ActiveRecord::Base.connection.table_exists? "drone_roles"
  		drop_table :drone_roles
  	end
  end

  def down
  end
end
