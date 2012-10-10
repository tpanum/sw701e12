class CreateDronesPrivilegesJoin < ActiveRecord::Migration
def up
  	create_table :drones_privileges, :id => false do |t|
  		t.integer "drone_id"
  		t.integer "privilege_id"
  	end
  	add_index :drones_privileges, ["drone_id", "privilege_id"]
  end

  def down
  	drop_table :drones_privileges
  end
end
