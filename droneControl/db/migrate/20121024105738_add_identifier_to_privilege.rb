class AddIdentifierToPrivilege < ActiveRecord::Migration
  def up
    remove_column :privileges, :description
    add_column :privileges, :description, :text, :after => :id
    add_column :privileges, :identifier, :string, :after => :id
    add_index :privileges, :identifier
  end

  def down
    remove_index :privileges, :identifier
    remove_column :privileges, :identifier
    remove_column :privileges, :description
    add_column :privileges, :description, :string, :after => :id
  end
end
