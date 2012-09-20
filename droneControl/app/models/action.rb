class Action < ActiveRecord::Base
  # attr_accessible :title, :body

  has_one :instruction
  belongs_to :flight_action_relationships
end
