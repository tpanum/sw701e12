class Drone < ActiveRecord::Base
   attr_accessible :IP, :name, :location, :description

  has_many :flight_plans
  has_many :user_drone_privileges
  has_many :users, :through => :user_drone_privileges
end
