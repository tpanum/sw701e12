class DronesController < ApplicationController

  before_filter :confirm_logged_in

  def index
    @drones = Drone.order("name ASC")
  end

  def show
    @drone = Drone.find(params[:id])
    if !@drone.session.nil? && !@drone.session.session_key.nil?
      # The user should ONLY be able to watch the stream
    else
      Session.create(:user => User.find(session[:user_id]), :drone => @drone)
      SessionKeyTask.create(:drone => @drone)
    end
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
    Drone.find(params[:id]).unlink

    flash[:notice] = "The Drone has been unlinked"
    redirect_to(:action => 'index')
  end

  def get_information
    @drone = Drone.where(:name => params[:query]).limit(1).first

    @companies = User.find(session[:user_id]).companies | User.find(session[:user_id]).owned_companies

    respond_to do |format|
      format.json { render json: {"drone" => @drone, "companies" => @companies} }
    end
  end

  def link_drone_to_company
    @drone = Drone.find(params[:drone_id])
    @company = Company.find(params[:company_id])
    @drone.company = @company
    @drone.save

    flash[:notice] = "Drone linked to #{@drone.company.name}"
    redirect_to(:action => 'index')
  end
end
