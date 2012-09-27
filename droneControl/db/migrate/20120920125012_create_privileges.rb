class CreatePrivileges < ActiveRecord::Migration
  def change
    create_table :privileges do |t|
      t.string "description"
      t.references :roles
      t.timestamps
    end

    change_table :privileges do |t|
      t.index :roles_id
    end
  end
end
