class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email params[:email]
    if user && user.authenticate(params[:password])
      sign_in(user)
      redirect_to user_path(user), notice: "Sign in successful!"
    else
      flash[:alert] = "Wrong credentials!"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path, notice: "You are logged out!"
  end
end
