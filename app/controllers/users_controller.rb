class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy, :check_password]

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      sign_in(@user)
      redirect_to user_path(@user), notice: "Sign up successful!"
    else
      flash[:alert] = "Sign up unsuccessful."
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if (params[:user][:password].blank? || password_checks_ok?) && (@user.update user_params)
      redirect_to @user, notice: "Profile updated successfully."
    else
      flash[:alert] = "Profile not updated."
      (params[:user][:password].present?) ? (render :change_password) : (render :edit)
    end
  end

  def destroy
  end

  def change_password
    @user = User.find params[:user_id]
  end

  private

  def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find params[:id]
  end

  def password_checks_ok?
    new_password = params[:user]["password"]
    old_password = params[:user]["current_password"]

    authenticated_user = @user.authenticate(old_password)
    passwords_different = (old_password != new_password)

    authenticated_user && passwords_different
  end

end
