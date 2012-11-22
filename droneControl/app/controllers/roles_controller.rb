class RolesController < ApplicationController

  before_filter :confirm_logged_in

  def index
    @companies = User.find(session[:user_id]).companies | User.find(session[:user_id]).owned_companies

    @roles = Role.where(:level_type => 2).includes(:companies).where("companies.id IN (?)", @companies)
  end

  def show
    @role = Role.find(params[:id])
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(params[:role])

    if @role.save
      flash[:notice] = "Role created."
      redirect_to(:action => 'index')
    else
      render('new')
    end
  end

  def edit
    @role = Role.find(params[:id])
  end

  def update
    @role = Role.find(params[:id])

    if @role.update_attributes(params[:role])
      flash[:notice] = "Role updated."
      redirect_to(:action => 'edit', :id => @role.id)
    else
      render('edit')
    end
  end

  def destroy
    Role.find(params[:id]).destroy

    flash[:notice] = "The Role has been destroyed"
    redirect_to(:action => 'index')
  end

  def add_privileges
    @role = Role.find(params[:id])
    @privileges = AffiliatePrivilege.where(:id => params[:privileges])
    @role.privileges << @privileges
    respond_to do |format|
      format.json { render json: @role.privileges }
    end
  end

  def remove_privileges
    @role = Role.find(params[:id])
    @privileges = AffiliatePrivilege.where(:id => params[:privileges])
    @role.privileges.delete(@privileges)
    respond_to do |format|
      format.json { render json: @role.privileges }
    end
  end

  def add_users
    @role = Role.find(params[:id])
    @users = User.where(:id => params[:users])
    @role.users << @users
    respond_to do |format|
      format.json { render json: @role.users }
    end
  end

  def remove_users
    @role = Role.find(params[:id])
    @users = User.where(:id => params[:users])
    @role.users.delete(@users)
    respond_to do |format|
      format.json { render json: @role.users }
    end
  end

end
