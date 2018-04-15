class DepartmentsController < ApplicationController
  def index
    @departments = Department.all
  end

  def show
    return if params[:board_id].nil?

    @department = Department.find(params[:id])
    @board = Board.find(params[:board_id])
    @terms = @board.terms

    @terms.each do |term|
      @terms.delete(term) unless @department.terms.include?(term)
    end
  end

  def new; end

  def create
    @department = Department.new(params.require(:department).permit(:title))
    @department.save

    redirect_to departments_path
  end

  def destroy
    department = Department.find(params[:id])
    department.destroy

    redirect_to departments_path
  end
end
