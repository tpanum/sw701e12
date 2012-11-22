class Privilege < ActiveRecord::Base
  attr_accessible :description, :identifier, :instance_type

  has_many :affiliate_privileges

  def type
    unless self.instance_type.nil?
      Privilege.type_enums[self.instance_type]
    else
      self.instance_type
    end
  end

  def type=(value)
  	v = Privilege.type_enums.index(value)
  	raise "Type does not exist!" if v.nil?
  	self.instance_type = v
  end

  def self.type_enums
  	["global","company","drone"]
  end

  def as_json(options={})
    super(options.merge(:only => [:id, :identifier, :description]))
  end
end
