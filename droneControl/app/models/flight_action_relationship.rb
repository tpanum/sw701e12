class FlightActionRelationship < ActiveRecord::Base
  # attr_accessible :title, :body

  belongs_to :action
  belongs_to :flight_plan
end
