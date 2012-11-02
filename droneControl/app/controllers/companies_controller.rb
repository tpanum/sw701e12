class CompaniesController < ApplicationController

  before_filter :confirm_logged_in

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @companies }
    end
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
    @company = Company.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @company }
    end
  end

  # GET /companies/new
  # GET /companies/new.json
  def new
    @company = Company.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @company }
    end
  end

  # GET /companies/1/edit
  def edit
    @company = Company.find(params[:id])
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(params[:company])
    @company.owner = User.find(session[:user_id])

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render json: @company, status: :created, location: @company }
      else
        format.html { render action: "new" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /companies/1
  # PUT /companies/1.json
  def update
    @company = Company.find(params[:id])

    respond_to do |format|
      if @company.update_attributes(params[:company])
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company = Company.find(params[:id])
    @company.destroy

    respond_to do |format|
      format.html { redirect_to companies_url }
      format.json { head :no_content }
    end
  end

  def users
    @company = Company.find(params[:id])
    @users_comp = @company.users
    @users_all = User.find(:all, :conditions => ['id not in (?)', @users_comp.map(&:id)])
  end

  def companies_users
    @company = Company.find(params[:id])
    @user = User.find(params[:user_id])

    if params[:perform].eql?("add")
      puts "succes"
      respond_to do |format|
        if @company.users << @user
          format.html { redirect_to @company, notice: 'User was successfully added to company.' }
          format.json { head :no_content }
        else
          format.html { render action: "users" }
          format.json { render json: @company.errors, status: :unprocessable_entity }
        end
      end
    elsif params[:perform].eql?("remove")
      puts "succes"
      respond_to do |format|
        if @company.users.delete(@user)
          format.html { redirect_to @company, notice: 'User was successfully removed from company.' }
          format.json { head :no_content }
        else
          format.html { render action: "users" }
          format.json { render json: @company.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def drones
    @company = Company.find(params[:id])
  end

  def companies_drones
    @company = Company.find(params[:id])
    @drone = Drone.where(:name => params[:companies_drones][:drone_name]).limit(1).first

    respond_to do |format|
      if @company.drones << @drone
        format.html { redirect_to @company, notice: 'Drone was successfully added to company.' }
        format.json { head :no_content }
      else
        format.html { render action: "drones" }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end
end
