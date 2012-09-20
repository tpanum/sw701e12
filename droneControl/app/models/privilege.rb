class Privilege < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :role
end
