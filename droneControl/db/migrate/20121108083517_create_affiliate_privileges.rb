class CreateAffiliatePrivileges < ActiveRecord::Migration
  def change
    create_table :affiliate_privileges do |t|
      t.references :privilege
      t.integer :affiliate
      t.timestamps
    end
  end
end
