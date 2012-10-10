class CreatePrivilegeRolesJoin < ActiveRecord::Migration
  def up
  	create_table :privileges_roles, :id => false do |t|
  		t.integer "privilege_id"
  		t.integer "role_id"
  	end	
  	add_index :privileges_roles, ["privilege_id", "role_id"]
  end

  def down
  	drop_table :privileges_roles
  end
end
