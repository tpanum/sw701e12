class ChangeUserPrivilegeToUseAffiliatePrivileges < ActiveRecord::Migration
  def up
    remove_index :user_privileges, :name => "index_user_privileges_on_user_id_and_privilege_id"
    remove_column :user_privileges, :privilege_id
    add_column :user_privileges, :affiliate_privilege_id, :integer, :after => :user_id
    add_index :user_privileges, ["user_id", "affiliate_privilege_id"]
  end

  def down
    
    remove_index :user_privileges, :name => "index_user_privileges_on_user_id_and_affiliate_privilege_id"
    remove_column :user_privileges, :affiliate_privilege_id
    add_column :user_privileges, :privilege_id, :integer, :after => :user_id
    add_index :user_privileges, ["user_id", "privilege_id"]
    
  end
end
