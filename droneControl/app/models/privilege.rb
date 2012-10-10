class Privilege < ActiveRecord::Base
  # attr_accessible :title, :body

  has_and_belongs_to_many :roles
  has_many :drones
  has_many :users, :through => :user_privileges
end
