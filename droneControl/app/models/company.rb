class Company < ActiveRecord::Base
  attr_accessible :name

  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  has_many :company_drones
  has_many :drones, :through => :company_drones, :uniq => true
  has_many :company_roles
  has_many :roles, :through => :company_roles, :uniq => true
  has_and_belongs_to_many :users

  after_create :create_company_role
  after_destroy :destroy_all_roles, :destroy_all_drones

  private
  def create_company_role
    role_name = self.name.gsub(" ", "_") + "_All"
    r = Role.create(:title => role_name, :level_type => 1)
    self.roles << r
  end

  def destroy_all_roles
    roles.each do |r|
      r.destroy
    end
  end

  def destroy_all_drones
    drones.each do |d|
      d.destroy
    end
  end
end
