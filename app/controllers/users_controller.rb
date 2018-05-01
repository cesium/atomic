class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(:cesium_id, :student_id, :name,
      :phone_number, :email, :course, :image)
  end
end
