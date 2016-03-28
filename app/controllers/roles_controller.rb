class RolesController < ApplicationController
  def index
    @roles = Role.all
  end

  def new
  end

  def create
    @role = Role.new(params.require(:role).permit(:title))
    @role.save

    redirect_to roles_path
  end

  def destroy
    role  = Role.find(params[:id])
    role.destroy

    redirect_to roles_path
  end
end
