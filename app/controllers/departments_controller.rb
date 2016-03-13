class DepartmentsController < ApplicationController
  def show
    @department   = Department.find(params[:id])
    @board        = Board.find(params[:board_id])
    # Terms associated with the given board.
    @board_terms  = Board.find(params[:board_id]).terms
    # IDs of the roles of a department.
    role_ids      = Department.find(params[:id]).roles.ids

    @board_terms.each do |term|
      if (!role_ids.include?(term.role_id)) then
        @board_terms.delete(term)
      end
    end
  end

  def new
  end

  def create
    @department = Department.new(params.require(:department).permit(:title))
    @department.save

    redirect_to boards_path
  end
end
