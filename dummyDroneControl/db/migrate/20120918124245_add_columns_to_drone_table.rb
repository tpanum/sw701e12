class AddColumnsToDroneTable < ActiveRecord::Migration
  def change
    change_table :drones do |t|
      t.string :ip_address
      t.integer :seq
    end
  end
end
