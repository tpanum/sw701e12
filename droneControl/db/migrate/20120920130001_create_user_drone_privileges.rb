class CreateUserDronePrivileges < ActiveRecord::Migration
  def change
    create_table :user_drone_privileges do |t|
      t.references :users
      t.references :drones
      t.references :drone_roles
      t.timestamps
    end

    change_table :user_drone_privileges do |t| 
      t.index :users_id
      t.index :drones_id
      t.index :drone_roles_id
    end
  end
end
