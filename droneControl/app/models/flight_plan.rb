class FlightPlan < ActiveRecord::Base
  # attr_accessible :title, :body

  has_many :flight_action_relationships
  belongs_to :drone
end
