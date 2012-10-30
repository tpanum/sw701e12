class CreateCompanyDrones < ActiveRecord::Migration
  def up
    drop_table :companies_drones
    create_table :company_drones do |t|
        t.references :company
        t.references :drone
        t.timestamps
    end
    add_index :company_drones, ["company_id", "drone_id"]
  end

  def down
    drop_table :company_drones
    create_table :companies_drones, :id => false do |t|
        t.references :company
        t.references :drone
    end
    add_index :companies_drones, ["company_id", "drone_id"]
  end
end
