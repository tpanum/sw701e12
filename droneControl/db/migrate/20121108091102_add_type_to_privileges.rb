class AddTypeToPrivileges < ActiveRecord::Migration
  def change
    add_column :privileges, :instance_type, :integer, :after => :description
  end
end
