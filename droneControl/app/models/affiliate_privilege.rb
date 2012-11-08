class AffiliatePrivilege < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :privilege
  has_many :user_privileges
  has_many :users, :through => :user_privileges, :uniq => true
end
