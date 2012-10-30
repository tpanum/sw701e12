class CompanyRole < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :company
  belongs_to :role
end
