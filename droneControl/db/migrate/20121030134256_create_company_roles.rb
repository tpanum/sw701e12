class CreateCompanyRoles < ActiveRecord::Migration
  def up
    drop_table :companies_roles
    create_table :company_roles do |t|
        t.references :company
        t.references :role

        t.timestamps
    end
    add_index :company_roles, ["company_id", "role_id"]
  end

  def down
    drop_table :company_roles
    create_table :companies_roles, :id => false do |t|
        t.references :company
        t.references :role
    end
    add_index :companies_roles, ["company_id", "role_id"]
  end
end
