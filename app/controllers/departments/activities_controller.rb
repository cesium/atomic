class Departments::ActivitiesController < ApplicationController
  def index
    dep = Department.find_by(title: params[:department_id])
    @activities = Activity.where(department_id: dep.id).paginate(page: params[:page], per_page: 5)
  end
end
