class UsersController < ApplicationController

  before_filter :confirm_logged_in

  def index
  	list
  	render('list')
  end

  def list
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
  	  redirect_to(:action => 'list')
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
  	redirect_to(:action => 'list')
  end

  def search
    @users = User.where("first_name LIKE ?", "#{params[:query]}%").limit(3)
    respond_to do |format|
      format.json { render json: @users }
    end
  end
end
