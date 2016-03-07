class ActivitiesController < ApplicationController

  def new
    @activity = Activity.new
  end

  def index
    @activities = Activity.all
  end

  def show
    @activity = Activity.find(params[:id])
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to @activity
    else
      render :new
    end
  end

  private
    def activity_params
      params.require(:activity).permit(:name, :location, :description, :total_rating, :member_cost, :guest_cost, :start_date, :end_date, :coffee_break, :poster, :department_id)
    end

end
