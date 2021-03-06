class UsersController < ApplicationController

  before_filter :confirm_logged_in

  def index
    @users = User.order("first_name ASC")
  end

  def show
    @user = User.find(params[:id])
  end

  def new
  	@user = User.new
  end

  def create
  	@user = User.new(params[:user])

  	if @user.save
  	  flash[:notice] = "User created."
  	  redirect_to(:action => 'index')
  	else
  	  render('new')
  	end
  end

  def edit
  	@user = User.find(params[:id])
  end

  def update
  	@user = User.find(params[:id])

  	if @user.update_attributes(params[:user])
  	  flash[:notice] = "User updated."
  	  redirect_to(:action => 'edit', :id => @user.id)
  	else
  	  render('edit')
  	end
  end

  def delete
  	@user = User.find(params[:id])
  end

  def destroy
  	User.find(params[:id]).destroy

  	flash[:notice] = "The user has been destroyed"
  	redirect_to(:action => 'index')
  end

  def search
    @role = Role.find(params[:role_id])
    @users = []
    @role.companies.each do |c|
      @users |= c.users.where("CONCAT(IFNULL(first_name,''), ' ', IFNULL(last_name,'')) LIKE ?", "#{params[:query]}%").order(:first_name).order(:last_name).limit(3)
    end
    respond_to do |format|
      format.json { render json: @users }
    end
  end
end
