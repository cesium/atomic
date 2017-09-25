class ActivitiesController < ApplicationController
  before_action :set_activity, except: [:index, :new, :create]
  load_and_authorize_resource

  def new
    @activity = Activity.new
  end

  def index
    @activities = Activity.all.order('start_date DESC')
      .paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def create
    @activity = Activity.new(activity_params)
    if @activity.save
      redirect_to @activity
    else
      render :new
    end
  end

  def update
    if @activity.update(activity_params)
      redirect_to @activity
    else
      render :edit
    end
  end

  def destroy
    @activity.destroy
    redirect_to @activity
  end

  private
    def activity_params
      params.require(:activity).permit(:name, :location, :description, :total_rating, :member_cost, :guest_cost, :start_date, :end_date, :coffee_break, :poster, :department_id)
    end

    def set_activity
      @activity = Activity.find(params[:id])
    end

end
