class SessionsController < ApplicationController

  def new
    
  end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Logged in succesfully"
      redirect_to user
    else
      flash.now[:alert] = "There was something wrong with your login details."
      render 'new'
    end
  end
  
  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to root_path
  end

  private

  def session_params
    params.require(:session).permit(:username, :email, :password)
  end

end
