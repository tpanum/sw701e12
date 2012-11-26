class AddCompanyIdToDroneTable < ActiveRecord::Migration
  def change
    add_column :drones, :company_id, :int, :after => :description
  end
end
