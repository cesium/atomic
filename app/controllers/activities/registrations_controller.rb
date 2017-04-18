class Activities::RegistrationsController < ApplicationController
  before_action :set_activity
  load_and_authorize_resource

  def create
    unless @activity.registered?(current_user)
      registration = Registration.create(activity_id: @activity.id, user_id: current_user.id)
    end
    redirect_to @activity
  end

  def index
    @participants = @activity.participants
    @registrations = @activity.registrations
  end

  def update
    @activity
      .registrations
      .find_by(user_id: registration_params[:participant_id])
      .update_attributes(confirmed: true)
    redirect_to activity_participants_path
  end

  private

  def registration_params
    params.permit(:activity_id, :participant_id)
  end

  def set_activity
    @activity = Activity.find(registration_params[:activity_id])
  end
end
