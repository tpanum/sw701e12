class Company < ActiveRecord::Base
  attr_accessible :name

  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  has_and_belongs_to_many :drones
  has_and_belongs_to_many :roles
  has_and_belongs_to_many :users

  after_create :create_company_role
  after_destroy :destroy_all_roles, :destroy_all_drones

  private
  def create_company_role
    r = Role.create(:title => "All", :level_type => 1)
    self.roles << r
  end

  def destroy_all_roles
    self.roles.each do |r|
      r.destroy
    end
  end

  def destroy_all_drones
    self.drones.each do |d|
      d.destroy
    end
  end
end
