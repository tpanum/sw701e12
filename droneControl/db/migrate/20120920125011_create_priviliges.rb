class CreatePriviliges < ActiveRecord::Migration
  def change
    create_table :priviliges do |t|
      t.string "description"
      t.timestamps
    end
  end
end
