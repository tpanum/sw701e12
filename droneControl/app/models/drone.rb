class Drone < ActiveRecord::Base
  attr_accessible :ip, :name, :location, :description, :session_key

  has_many :flight_plans
  has_many :privileges
  has_many :users, :through => :user_drone_privileges

  after_save :create_privileges
  after_destroy :drop_privileges

  private

  def create_privileges
  	@p1 = Privilege.new(:description => "fly_drone_" + self.name)
  	@p1.save
  	@p2 = Privilege.new(:description => "view_drone_" + self.name)
  	@p2.save
  end

  def drop_privileges
  	self.privileges.each do |p|
  	 p.destroy
  	end
  end
end
