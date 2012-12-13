class UserPrivilege < ActiveRecord::Base
  attr_accessible :user, :affiliate_privilege, :flag
  belongs_to :user
  belongs_to :affiliate_privilege
end
