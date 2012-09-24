class CreateDroneRoles < ActiveRecord::Migration
  def change
    create_table :drone_roles do |t|
      t.string "title"
      t.timestamps
    end
  end
end
