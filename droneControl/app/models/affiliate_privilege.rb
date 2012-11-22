class AffiliatePrivilege < ActiveRecord::Base
  attr_accessible :privilege, :affiliate
  belongs_to :privilege
  has_many :user_privileges
  has_many :users, :through => :user_privileges, :uniq => true
  has_and_belongs_to_many :roles, :uniq => true

  before_save :check_if_global

  def check_if_global
  	unless self.privilege.nil?
  		self.affiliate = 0 if self.privilege.type == "global"
  	end
  end

  def as_json(options={})
    json = super(options.merge(:only => [:id, :affiliate, :privilege_id]))
    json["identifier"] = self.identifier
    json["description"] = self.description
    json["type"] = self.type
    json
  end

  def identifier
    self.privilege.identifier
  end

  def description
    self.privilege.description
  end

  def type
    self.privilege.type
  end

end
