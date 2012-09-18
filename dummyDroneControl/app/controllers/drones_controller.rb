class DronesController < ApplicationController
  def index
    
  end
  
  def takeoff
    @drone = Drone.new
    @drone.setup("192.168.1.1", "5556")
    @drone.takeoff
  end
  
  def landing
    @drone = Drone.new
    @drone.setup("192.168.1.1", "5556")
    @drone.land
  end
end
