class AffiliatePrivilegesController < ApplicationController
  # GET /affiliate_privileges
  # GET /affiliate_privileges.json
  def index
    @affiliate_privileges = AffiliatePrivilege.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @affiliate_privileges }
    end
  end

  # GET /affiliate_privileges/1
  # GET /affiliate_privileges/1.json
  def show
    @affiliate_privilege = AffiliatePrivilege.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @affiliate_privilege }
    end
  end

  # GET /affiliate_privileges/new
  # GET /affiliate_privileges/new.json
  def new
    @affiliate_privilege = AffiliatePrivilege.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @affiliate_privilege }
    end
  end

  # GET /affiliate_privileges/1/edit
  def edit
    @affiliate_privilege = AffiliatePrivilege.find(params[:id])
  end

  # POST /affiliate_privileges
  # POST /affiliate_privileges.json
  def create
    @affiliate_privilege = AffiliatePrivilege.new(params[:affiliate_privilege])

    respond_to do |format|
      if @affiliate_privilege.save
        format.html { redirect_to @affiliate_privilege, notice: 'Affiliate privilege was successfully created.' }
        format.json { render json: @affiliate_privilege, status: :created, location: @affiliate_privilege }
      else
        format.html { render action: "new" }
        format.json { render json: @affiliate_privilege.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /affiliate_privileges/1
  # PUT /affiliate_privileges/1.json
  def update
    @affiliate_privilege = AffiliatePrivilege.find(params[:id])

    respond_to do |format|
      if @affiliate_privilege.update_attributes(params[:affiliate_privilege])
        format.html { redirect_to @affiliate_privilege, notice: 'Affiliate privilege was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @affiliate_privilege.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /affiliate_privileges/1
  # DELETE /affiliate_privileges/1.json
  def destroy
    @affiliate_privilege = AffiliatePrivilege.find(params[:id])
    @affiliate_privilege.destroy

    respond_to do |format|
      format.html { redirect_to affiliate_privileges_url }
      format.json { head :no_content }
    end
  end
end
