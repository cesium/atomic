class RolesController < ApplicationController
  def new
  end

  def create
    @role = Role.new(params.require(:role).permit(:title, :department_id))
    @role.save

    Department.find(params[:department_id]).roles << @role

    redirect_to boards_path
  end
end
