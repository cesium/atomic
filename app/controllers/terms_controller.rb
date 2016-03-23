class TermsController < ApplicationController
  def new
    @roles        = Role.all.pluck(:title)
    @departments  = Department.all.pluck(:title)
  end

  def create
    @term = Term.new(params.require(:term).permit(:user_id, :role_id, :board_id, :department_id))
    @term.save

    User.find(params[:term][:user_id]).terms                            << @term
    Role.where(title: params[:term][:role_id]).first.terms              << @term
    Board.find(params[:board_id]).terms                                 << @term
    Department.where(title: params[:term][:department_id]).first.terms  << @term

    redirect_to board_path(params[:board_id])
  end

  def destroy
    @term = Term.find(params[:id])
    @term.destroy

    redirect_to board_path(params[:board_id])
  end
end
