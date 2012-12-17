class AccessController < ApplicationController

  before_filter :confirm_logged_in, :except => [:login, :attempt_login, :logout]

  def index

  end

  def menu
  	#display menu
  end

  def login
    unless session[:user_id].nil?
      redirect_to(:controller => 'drones', :action => 'index')
    else
      render :layout => 'login'
    end
  	#login form
  end

  def attempt_login
  	authorized_user = User.authenticate(params[:email], params[:password])

  	if authorized_user
      if params[:remember_email] == "1"
        session[:_user_email] = params[:email]
        session[:_remember_email] = true
      else
        session[:_user_email] = nil
        session[:_remember_email] = false
      end
  	  session[:user_id] = authorized_user.id
  	  session[:user_email] = authorized_user.email

  	  flash[:notice] = "You are now logged in!"
      redirect_to(:controller => 'drones', :action => 'index')
  	else
  	  flash[:notice] = "Wrong email/password combination"
  	  redirect_to(:action => 'login')
  	end
  end

  def logout
  	session[:user_id] = nil
  	session[:user_email] = nil

  	flash[:notice] = "You are now logged out"
  	redirect_to(:action => 'login')
  end
end
