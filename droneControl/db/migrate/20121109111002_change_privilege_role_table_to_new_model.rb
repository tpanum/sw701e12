class ChangePrivilegeRoleTableToNewModel < ActiveRecord::Migration
  def up
  	drop_table :privileges_roles
  	create_table :affiliate_privileges_roles, :id => false do |t|
  		t.integer "affiliate_privilege_id"
  		t.integer "role_id"
  	end	
  	add_index :affiliate_privileges_roles, ["affiliate_privilege_id"]
  	add_index :affiliate_privileges_roles, ["role_id"]
  end

  def down
  	drop_table :affiliate_privileges_roles
  	create_table :privileges_roles, :id => false do |t|
  		t.integer "privilege_id"
  		t.integer "role_id"
  	end	
  	add_index :privileges_roles, ["privilege_id", "role_id"]
  end
end

