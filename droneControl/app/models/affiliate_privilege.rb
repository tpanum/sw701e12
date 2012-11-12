class AffiliatePrivilege < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :privilege
  has_many :user_privileges
  has_many :users, :through => :user_privileges, :uniq => true

  before_save :check_if_global

  def check_if_global
  	unless self.privilege.nil?
  		self.affiliate = 0 if self.privilege.type == "global"
  	end
  end

end
