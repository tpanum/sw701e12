class Role < ActiveRecord::Base
  attr_accessible :title, :level_type
  # types are: 0 for GP, 1 for All, 2 for everything else

  has_many :company_roles
  has_many :companies, :through => :company_roles, :uniq => true
  has_and_belongs_to_many :_privileges, :class_name => 'Privilege', :uniq => true
  has_and_belongs_to_many :users, :uniq => true

  def privileges
    if self.level_type == 1
      gpr = Role.where(:level_type => 0).limit(1).first
      unless gpr.nil?
        gpr.privileges | self._privileges
      else
        self._privileges
      end
    else
      self._privileges
    end
  end
end
