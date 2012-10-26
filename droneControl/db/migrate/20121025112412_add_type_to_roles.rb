class AddTypeToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :level_type, :integer, :default => 2, :after => :title
  end
end
