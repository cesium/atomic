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
    registration = Registration.find(params[:registration_id])

    if params[:confirmed] == "true"
      registration.update_attribute(:confirmed, false)
      flash[:alert] =
        "Confirmação de #{User.find(registration_params[:participant_id]).name} cancelada!"
    else
      registration.update_attribute(:confirmed, true)
      flash[:success] =
        "#{User.find(registration_params[:participant_id]).name} confirmado!"
    end

    redirect_to activity_participants_path
  end

  def destroy
    registration = Registration.find_by(activity_id: @activity.id, user_id: current_user.id)
    registration.destroy

    redirect_to @activity
  end

  private

  def registration_params
    params.permit(:activity_id, :participant_id)
  end

  def set_activity
    @activity = Activity.find(registration_params[:activity_id])
  end
end
