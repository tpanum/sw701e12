class Privilege < ActiveRecord::Base
  attr_accessible :description, :identifier, :instance_type

  has_and_belongs_to_many :roles, :uniq => true
  has_many :drones
  has_many :affiliate_privileges

  def type
  	type_enums[self.instance_type]
  end

  def type=(value)
  	v = type_enums.index(value)
  	raise "Type does not exist!" if v.nil?
  	self.instance_type = v
  end

  def type_enums
  	["global","company","drone"]
  end

  def as_json(options={})
    super(options.merge(:only => [:id, :identifier, :description]))
  end
end
