class Drone < ActiveRecord::Base
  attr_accessible :ip, :name, :location, :description, :session_key

  has_many :flight_plans
  has_and_belongs_to_many :companies
  has_and_belongs_to_many :privileges
  has_many :users, :through => :user_drone_privileges

  after_initialize :temp_company
  after_create :create_privileges
  after_destroy :drop_privileges
  before_save :check_amount_companies, :move_privileges

  private
  def check_amount_companies
    raise "Too many companies" if self.companies.size > 1
  end

  def create_privileges
  	self.privileges << Privilege.create(:identifier => "fly_drone_" + self.name)
  	self.privileges << Privilege.create(:identifier => "view_drone_" + self.name)
  end

  def drop_privileges
  	self.privileges.each do |p|
      p.destroy
  	end
  end

  def move_privileges
    @temp_companies ||= []
    self.companies ||= []
    if ((@temp_companies | self.companies) - (@temp_companies & self.companies)).size > 0
      unless @temp_companies.nil?
        # Delete privileges of drone from @temp_companies
        @temp_companies.each do |c|
          c.roles.where(:level_type => 1).limit(1).first.privileges.delete self.privileges
        end
      end
      unless self.companies.nil?
        # Add privileges of drone to self.companies
        self.companies.each do |c|
          c.roles.where(:level_type => 1).limit(1).first.privileges << self.privileges
        end
      end
    end
  end

  def temp_company
    @temp_companies = self.companies
  end
end


# Privilege.where(:identifier => self.privileges.first).limit(1).first.roles.first.companies.first != self.companies.first

# parent_privileges = self.companies.first.roles.where(:level_type => 1).limit(1).first.privileges
# self.privileges.each do |sp|
#   if parent_privileges.include? sp
# end
