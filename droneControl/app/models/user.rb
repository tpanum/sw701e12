require 'digest/sha1'

class User < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :email, :first_name, :last_name, :password
  has_many :user_privileges
  has_many :privileges, :through => :user_privileges, :class_name => "AffiliatePrivilege", :source => :affiliate_privilege, :uniq => true
  has_many :owned_companies, :class_name => "Company"
  has_and_belongs_to_many :companies, :uniq => true
  has_and_belongs_to_many :roles, :uniq => true

  attr_accessor :password

  #validates_length_of :password, :within => 8..25, :on => :create

  before_save :create_hashed_password
  after_save :clear_password

  after_destroy :destroy_privileges

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

  def full_name
    self.first_name + ' ' + self.last_name
  end

  def has_privilege? privilege
    enums = Privilege.type_enums

    received_type = nil

    enums.each do |e|
      unless privilege[e.to_sym].nil?
        raise "Two many affiliate arguements" unless received_type.nil?
        received_type = e
      end
    end

    received_type = "global" if received_type.nil?

    aff = privilege[received_type.to_sym]
    aff ||= 0
    type = enums.index(received_type)
    action = privilege[:action]

    p_object = AffiliatePrivilege.where(:affiliate => aff).includes(:privilege).where("privileges.instance_type = ? AND privileges.identifier = ?", type, action).limit(1).first

    return false if p_object.nil?

    p_id = p_object.id
    p_user = UserPrivilege.where(:user_id => self.id, :affiliate_privilege_id => p_id).limit(1).first


    if !p_user.nil?
      if p_user.flag == 1
        return true
      else
        return false
      end
    end

    self.roles.collect{|r| r.privileges.collect(&:id)}.flatten.include? p_id
  end

  def as_json(options={})
    json = super(options.merge(:only => [:id, :first_name, :last_name, :email]))
    json[:full_name] = self.full_name
    json
  end

  private
  def create_hashed_password
  	unless password.blank?
  	  self.salt = User.make_salt(email) if salt.blank?
  	  self.hashed_password = User.hash_with_salt(password, salt)
  	end
  end

  def destroy_privileges
    self.user_privileges.each do |t|
      t.destroy
    end
  end

  def clear_password
  	self.password = nil
  end
end
