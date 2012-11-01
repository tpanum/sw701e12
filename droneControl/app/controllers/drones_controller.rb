class DronesController < ApplicationController

  before_filter :confirm_logged_in

  def index
    @drones = Drone.order("name ASC")
  end

  def show
    @drone = Drone.find(params[:id])
  end


  def new
    @drone = Drone.new
  end

  def create
    @drone = Drone.new(params[:drone])

    if @drone.save
      flash[:notice] = "Drone created."
      redirect_to(:action => 'index')
    else
      render('new')
    end
  end

  def edit
    @drone = Drone.find(params[:id])
  end

  def update
    @drone = Drone.find(params[:id])

    if @drone.update_attributes(params[:drone])
      flash[:notice] = "Drone updated."
      redirect_to(:action => 'edit', :id => @drone.id)
    else
      render('edit')
    end
  end

  def delete
    @drone = Drone.find(params[:id])
  end

  def destroy
    Drone.find(params[:id]).destroy

    flash[:notice] = "The Drone has been destroyed"
    redirect_to(:action => 'index')
  end
end
