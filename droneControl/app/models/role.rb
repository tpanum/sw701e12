class Role < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :privilege
end
