class CreateUserPrivileges < ActiveRecord::Migration
  def change
    create_table :user_privileges do |t|
    	t.references :user
    	t.references :privilege
    	t.integer "flag", :null => false
      t.timestamps
    end
    add_index :user_privileges, ["user_id", "privilege_id"]
  end
end
