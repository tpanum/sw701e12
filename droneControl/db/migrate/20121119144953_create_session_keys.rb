class CreateSessionKeys < ActiveRecord::Migration
  def change
    create_table :session_keys do |t|
      t.string :session_key, :length => 40
      t.references :drone
      t.timestamps
    end
  end
end
