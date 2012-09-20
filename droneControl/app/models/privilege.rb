class Privilege < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :roles
  has_many :drone_roles
end
