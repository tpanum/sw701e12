class CreateInstructions < ActiveRecord::Migration
  def change
    create_table :instructions do |t|
      t.string "AT_command"
      t.timestamps
    end
  end
end
