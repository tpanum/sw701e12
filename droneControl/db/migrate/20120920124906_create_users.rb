class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string "first_name"
      t.string "last_name"
      t.string "email", :default => "", :null => false
      t.string "salt"
      t.string "hashed_password"
      t.string "password"
      t.timestamps
    end
  end
end
