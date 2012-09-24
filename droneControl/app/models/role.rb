class Role < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :privileges
  has_many :users
end
