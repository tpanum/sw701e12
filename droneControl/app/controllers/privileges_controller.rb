class PrivilegesController < ApplicationController
  # GET /privileges
  # GET /privileges.json
  def index
    @privileges = Privilege.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @privileges }
    end
  end

  # GET /privileges/1
  # GET /privileges/1.json
  def show
    @privilege = Privilege.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @privilege }
    end
  end

  # GET /privileges/new
  # GET /privileges/new.json
  def new
    @privilege = Privilege.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @privilege }
    end
  end

  # GET /privileges/1/edit
  def edit
    @privilege = Privilege.find(params[:id])
  end

  # POST /privileges
  # POST /privileges.json
  def create
    @privilege = Privilege.new(params[:privilege])

    respond_to do |format|
      if @privilege.save
        format.html { redirect_to @privilege, notice: 'Privilege was successfully created.' }
        format.json { render json: @privilege, status: :created, location: @privilege }
      else
        format.html { render action: "new" }
        format.json { render json: @privilege.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /privileges/1
  # PUT /privileges/1.json
  def update
    @privilege = Privilege.find(params[:id])

    respond_to do |format|
      if @privilege.update_attributes(params[:privilege])
        format.html { redirect_to @privilege, notice: 'Privilege was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @privilege.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /privileges/1
  # DELETE /privileges/1.json
  def destroy
    @privilege = Privilege.find(params[:id])
    @privilege.destroy

    respond_to do |format|
      format.html { redirect_to privileges_url }
      format.json { head :no_content }
    end
  end

  def search
    @privileges = Company.find(4).roles.where(:level_type => 1).limit(1).first.privileges.includes(:privilege).where("privileges.identifier LIKE ?", "#{params[:query]}%")
    #@privileges -= Role.find(params[:role_id]).privileges unless params[:role_id].nil?
    #@privileges -= User.find(params[:user_id]).privileges unless params[:user_id]
    respond_to do |format|
      format.json { render json: @privileges }
    end
  end
end
