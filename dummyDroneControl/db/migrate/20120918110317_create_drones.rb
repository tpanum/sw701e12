class CreateDrones < ActiveRecord::Migration
  def change
    create_table :drones do |t|

      t.timestamps
    end
  end
end
