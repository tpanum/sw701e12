class CreateCompanyDroneJoin < ActiveRecord::Migration
  def change
    create_table :companies_drones, :id => false do |t|
        t.integer "company_id"
        t.integer "drone_id"
    end
    add_index :companies_drones, ["company_id", "drone_id"]
  end
end
