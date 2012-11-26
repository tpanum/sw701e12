class Company < ActiveRecord::Base
  attr_accessible :name

  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  has_many :drones
  has_many :company_roles
  has_many :roles, :through => :company_roles, :uniq => true
  has_and_belongs_to_many :users, :uniq => true

  after_create :create_company_role
  after_destroy :destroy_all_roles, :destroy_all_drones

  def privileges
    self.roles.where(:level_type => 1).limit(1).first.privileges
  end

  private
  def create_company_role
    # role_name = self.name.gsub(" ", "_") + "_All"
    self.roles << Role.create(:title => "All", :level_type => 1)
  end

  def destroy_all_roles
    roles.destroy_all
  end

  def destroy_all_drones
    drones.destroy_all
  end
end
