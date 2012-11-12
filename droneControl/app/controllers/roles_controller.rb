class RolesController < ApplicationController

  before_filter :confirm_logged_in

  def index
    @roles = Role.where(:level_type => [1,2]).order('title ASC')
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

  def privileges
    @user = User.find(session[:user_id])
    @privileges = Privilege.all
    if @user.has_privilege? :action => 'super_admin'
      @roles = Role.all
    else
      @roles = []
      @user.companies.each do |c|
        @roles |= c.roles
      end
      @roles |= @user.roles
    end
  end

  def get_privileges
    @role = Role.find(params[:id])
    respond_to do |format|
      format.json { render json: @role.privileges }
    end
  end

end
