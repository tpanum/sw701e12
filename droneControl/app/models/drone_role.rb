class DroneRole < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :privileges
  has_many :user_drone_privileges
end
