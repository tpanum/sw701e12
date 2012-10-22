require 'digest/sha1'

class User < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :email, :first_name, :last_name, :password
  has_many :user_privileges
  has_many :privileges, :through => :user_privileges
  has_and_belongs_to_many :roles

  attr_accessor :password

  #validates_length_of :password, :within => 8..25, :on => :create

  before_save :create_hashed_password
  after_save :clear_password

  attr_protected :hashed_password, :salt

  def self.authenticate(email="", password="")
  	user = User.find_by_email(email)

  	if user && user.password_match?(password)
  	  return user
  	else
  	  return false
  	 end
  end

  def password_match?(password="")
  	hashed_password == User.hash_with_salt(password, salt)
  end

  def self.make_salt(email="")
  	Digest::SHA1.hexdigest("Use #{email} with #{Time.now} to make salt")
  end

  def self.hash_with_salt(password="", salt="")
  	Digest::SHA1.hexdigest("Put #{salt} on the #{password}")
  end

  private
  def create_hashed_password
  	unless password.blank?
  	  self.salt = User.make_salt(email) if salt.blank?
  	  self.hashed_password = User.hash_with_salt(password, salt)
  	end
  end

  def clear_password
  	self.password = nil
  end

  def has_privilege? privilege
    p_id = Privilege.find_by_description(privilege).id
    p_roles_all = self.roles.collect{|r| r.privileges.collect(&:id)}.flatten
    p_roles_all.include? p_id
  end
end
