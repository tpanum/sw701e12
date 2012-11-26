class Drone < ActiveRecord::Base
  attr_accessible :ip, :name, :location, :description, :session

  has_many :flight_plans
  belongs_to :company
  has_many :users, :through => :user_drone_privileges
  has_many :session_key_tasks
  has_one :session

  after_create :create_privileges
  after_destroy :drop_privileges
  before_save :move_privileges

  def unlink
    self.company = nil
    self.description = nil
    self.save
  end

  def privileges
    AffiliatePrivilege.where(:affiliate => self.id).includes(:privilege).where("privileges.instance_type = ?", Privilege.type_enums.index("drone"))
  end

  private
  def create_privileges
    privileges = Privilege.where(:instance_type => Privilege.type_enums.index("drone"))
    privileges.each do |p|
      AffiliatePrivilege.create(:privilege => p, :affiliate => self.id)
    end
  end

  def drop_privileges
    AffiliatePrivilege.where(:affiliate => self.id).includes(:privilege).where("privileges.instance_type = ?", Privilege.type_enums.index("drone")).destroy_all
  end

  def move_privileges
    if self.company_id_changed?
      unless self.company_id_was.nil?
        Company.find(self.company_id_was).privileges.delete self.privileges
      end
      unless self.company.nil?
        self.company.privileges << self.privileges
      end
    end
  end
end
