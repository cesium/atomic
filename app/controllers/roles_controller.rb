class RolesController < ApplicationController
  def new
  end

  def create
    @role = Role.new(params.require(:role).permit(:title, :department_id))
    @role.save

    role_id       = @role.id
    user_id       = params[:role][:user_id]
    department_id = params[:role][:department_id]
    board_id      = params[:role][:board_id]

    term = Term.new(user_id: user_id, role_id: role_id, board_id: board_id)
    term.save
    User.find(user_id).terms << term

    redirect_to departments_path
  end
end
