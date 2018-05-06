class ActivitiesController < ApplicationController
  load_and_authorize_resource

  def new
    @activity = Activity.new
  end

  def index
    @activities = if previous_activities_requested?
                    Activity.previous_activities
                  else
                    Activity.next_activities
                  end

    @activities = @activities.paginate(page: params[:page], per_page: 5)
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

  def update
    @activity = Activity.find_by(id: params[:id])

    if @activity
      update_activity(activity_params)
    else
      not_found
    end
  end

  def destroy
    Activity.find_by(id: params[:id]).try(:destroy)
    redirect_to activities_path
  end

  private

  def update_activity(params)
    if @activity.update(params)
      redirect_to @activity
    else
      render :edit
    end
  end

  def activity_params
    params.require(:activity).permit(:name, :location, :description, :speaker,
      :total_rating, :member_cost, :limit_number_participants, :number_participants, :guest_cost, :start_date, :end_date,
      :coffee_break, :poster, :allows_registrations, :external_link)
  end

  def previous_activities_requested?
    params[:show] == "previous"
  end
end
