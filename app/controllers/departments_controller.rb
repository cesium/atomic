class DepartmentsController < ApplicationController
  def index
    @departments = Department.all
  end

  def show
    @department = Department.find(params[:id])
  end

  def new
  end

  def create
    @department = Department.new(params.require(:department).permit(:title))

    @department.save
    redirect_to @department
  end
end
