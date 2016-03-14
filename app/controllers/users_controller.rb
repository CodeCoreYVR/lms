class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]

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
    if @user.update user_params
      redirect_to user_path(@user), notice: "Profile updated successfully."
    else
      flash[:notice] = "Profile not updated."
    end
  end

  def destroy
  end

  private

  def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def find_user
    @user = User.find current_user.id
  end
end
