class DronesController < ApplicationController

  def index

  end

  def takeoff
    @drone = Drone.find(1)
    @drone.setup
    @drone.takeoff
    render 'blank'
  end

  def landing
    @drone = Drone.find(1)
    @drone.setup
    @drone.land
    render 'blank'
  end

  def backward
    @drone = Drone.find(1)
    @drone.setup
    @drone.backward
    render 'blank'
  end

  def forward
    @drone = Drone.find(1)
    @drone.setup
    @drone.forward
    render 'blank'
  end

  def left
    @drone = Drone.find(1)
    @drone.setup
    @drone.left
    render 'blank'
  end

  def right
    @drone = Drone.find(1)
    @drone.setup
    @drone.right
    render 'blank'
  end

  def hover
    @drone = Drone.find(1)
    @drone.setup
    #@drone.hover
    render 'blank'
  end

end
