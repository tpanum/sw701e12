class NewPrivilegeSchema < ActiveRecord::Migration
  def up
  	change_table :users do |t|
      t.remove "roles_id"
    end

    change_table :privileges do |t|
      t.remove "roles_id"
    end

  end

  def down
  end
end
