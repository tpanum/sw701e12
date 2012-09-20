class CreateDrones < ActiveRecord::Migration
  def change
    create_table :drones do |t|
      t.string "ip"
      t.string "location"
      t.string "name"
      t.text "description"
      t.timestamps
    end
  end
end
