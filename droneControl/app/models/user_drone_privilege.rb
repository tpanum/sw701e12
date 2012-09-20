class UserDronePrivilege < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :user
  belongs_to :drone
  belongs_to :drone_role
end
