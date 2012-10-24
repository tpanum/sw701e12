class UserPrivilege < ActiveRecord::Base
  attr_accessible :user, :privilege, :flag
  belongs_to :user
  belongs_to :privilege
end
