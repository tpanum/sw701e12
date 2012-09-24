class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer "duration"
      t.references :flight_action_relationships
      t.references :instructions
      t.timestamps
    end

    change_table :actions do |t|
      t.index :flight_action_relationships_id
      t.index :instructions_id
    end
  end
end
