class DronesController < ApplicationController
  
  def index
    
  end
  
  def takeoff
    @drone = Drone.new
    @drone.setup("192.168.1.1", "5556")
    @drone.takeoff
    render 'blank'
  end
  
  def landing
    @drone = Drone.new
    @drone.setup("192.168.1.1", "5556")
    @drone.land
    render 'blank'
  end
  
  def backward
    @drone = Drone.new
    @drone.setup("192.168.1.1", "5556")
    @drone.back
    render 'blank'
  end
  
  def left
    @drone = Drone.new
    @drone.setup("192.168.1.1", "5556")
    @drone.left
    render 'blank'
  end
  
  def forward
    @drone = Drone.new
    @drone.setup("192.168.1.1", "5556")
    @drone.forward
    render 'blank'
  end
  
  def right
    @drone = Drone.new
    @drone.setup("192.168.1.1", "5556")
    @drone.right
    render 'blank'
  end
  
  def hover
    @drone = Drone.new
    @drone.setup("192.168.1.1", "5556")
    @drone.hover
    render 'blank'
  end
  
end
