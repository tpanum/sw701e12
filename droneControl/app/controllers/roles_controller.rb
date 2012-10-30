class RolesController < ApplicationController
  def index
    @roles = Role.order('title ASC')
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

end
