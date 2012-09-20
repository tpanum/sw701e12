class User < ActiveRecord::Base
  # attr_accessible :title, :body

  has_one :role
  has_many :user_drone_privileges
  has_many :drones, :through => :user_drone_privileges
end
