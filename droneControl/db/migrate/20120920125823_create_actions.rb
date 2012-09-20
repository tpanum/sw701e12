class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.integer "duration"
      t.timestamps
    end
  end
end
