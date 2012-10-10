class Role < ActiveRecord::Base
  # attr_accessible :title, :body

  has_and_belongs_to_many :privileges, :users
  has_many :users
end
