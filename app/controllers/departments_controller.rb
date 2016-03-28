class DepartmentsController < ApplicationController
  def index
    @departments  = Department.all
  end

  def show
    @department = Department.find(params[:id])

    if (params[:board_id] != nil) then
      @board    = Board.find(params[:board_id])
      @terms    = @board.terms

      @terms.each do |term|
        if !@department.terms.include?(term) then
          @terms.delete(term)
        end
      end
    end
  end

  def new
  end

  def create
    @department = Department.new(params.require(:department).permit(:title))
    @department.save

    redirect_to departments_path
  end

  def destroy
    department  = Department.find(params[:id])
    department.destroy

    redirect_to departments_path
  end
end
