class AccessController < ApplicationController

  before_filter :confirm_logged_in, :except => [:login, :attempt_login, :logout]

  def index

  end

  def menu
  	#display menu
  end

  def login
  	#login form
  end

  def attempt_login
  	authorized_user = User.authendicate(params[:email], params[:password])

  	if authorized_user
  	  session[:user_id] = authorized_user.id
  	  session[:user_email] = authorized_user.email

  	  flash[:notice] = "You are now logged in!"
  	  redirect_to(:action => 'menu')
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
