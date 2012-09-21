class UserDronePrivilege < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :user
  belongs_to :drone
  has_one :drone_role
end
