class TermsController < ApplicationController
  def new
  end

  def create
    @term = Term.new(params.require(:term).permit(:user_id, :role_id, :board_id, :department_id))
    @term.save

    User.find(params[:term][:user_id]).terms              << @term
    Role.find(params[:term][:role_id]).terms              << @term
    Board.find(params[:board_id]).terms                   << @term
    Department.find(params[:term][:department_id]).terms  << @term

    redirect_to board_path(params[:board_id])
  end

  def destroy
    @term = Term.find(params[:id])
    @term.destroy

    redirect_to board_path(params[:board_id])
  end
end
