class CreateCompaniesRolesJoin < ActiveRecord::Migration
  def change
    create_table :companies_roles, :id => false do |t|
        t.integer "company_id"
        t.integer "role_id"
    end
    add_index :companies_roles, ["company_id", "role_id"]
  end
end
