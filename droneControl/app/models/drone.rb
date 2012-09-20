class Drone < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :flight_plans
  has_many :user_drone_privileges
  has_many :users, :through => :user_drone_privileges
end
