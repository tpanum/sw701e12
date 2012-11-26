class RemoveCompanyDrone < ActiveRecord::Migration
  def up
    drop_table :company_drones
  end

  def down
    create_table :company_drones do |t|
      t.references :company
      t.references :drone
      t.timestamps
    end
  end
end
