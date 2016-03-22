class Activities::DepartmentsController < ApplicationController

  def index
    department = Department.find_by(name: params[:department]).id
    @activities = Activity.where(department_id: department).paginate(page: params[:page], per_page: 5)
  end

end
