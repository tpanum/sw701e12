class RolesController < ApplicationController
<<<<<<< HEAD
  # GET /roles
  # GET /roles.json
  def index
    @roles = Role.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @roles }
    end
  end

  # GET /roles/1
  # GET /roles/1.json
  def show
    @role = Role.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @role }
    end
  end

  # GET /roles/new
  # GET /roles/new.json
  def new
    @role = Role.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @role }
    end
  end

  # GET /roles/1/edit
=======
  def index
    list
    render('list')
  end

  def list
    @roles = Role.order('name ASC')
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
      redirect_to(:action => 'list')
    else
      render('new')
    end
  end

>>>>>>> rolemaker
  def edit
    @role = Role.find(params[:id])
  end

<<<<<<< HEAD
  # POST /roles
  # POST /roles.json
  def create
    @role = Role.new(params[:role])

    respond_to do |format|
      if @role.save
        format.html { redirect_to @role, notice: 'Role was successfully created.' }
        format.json { render json: @role, status: :created, location: @role }
      else
        format.html { render action: "new" }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /roles/1
  # PUT /roles/1.json
  def update
    @role = Role.find(params[:id])

    respond_to do |format|
      if @role.update_attributes(params[:role])
        format.html { redirect_to @role, notice: 'Role was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.json
  def destroy
    @role = Role.find(params[:id])
    @role.destroy

    respond_to do |format|
      format.html { redirect_to roles_url }
      format.json { head :no_content }
    end
=======
  def update
    @role = Role.find(params[:id])

    if @role.update_attributes(params[:role])
      flash[:notice] = "Role updated."
      redirect_to(:action => 'edit', :id => @role.id)
    else
      render('edit')
    end
  end

  def delete
    @role = Role.find(params[:id])
  end

  def destroy
    Role.find(params[:id]).destroy

    flash[:notice] = "The Role has been destroyed"
    redirect_to(:action => 'list')
>>>>>>> rolemaker
  end
end
