class NewPrivilegeSchema < ActiveRecord::Migration
  def change
  	change_table :users do |t|
      t.remove "roles_id"
    end

    change_table :privileges do |t|
      t.remove "roles_id"
    end

  end
end
