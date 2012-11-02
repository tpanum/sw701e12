class Privilege < ActiveRecord::Base
  attr_accessible :description, :identifier

  has_and_belongs_to_many :roles, :uniq => true
  has_many :drones
  has_many :users, :through => :user_privileges, :uniq => true
end
