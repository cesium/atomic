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
    @registrations = @activity.registrations.order('id')
  end

  def update
    registration = @activity
      .registrations
      .find_by(user_id: registration_params[:participant_id])
    registration.update_attribute(:confirmed, registration_params[:confirmed])
    user = User.find(registration_params[:participant_id])

    if registration.confirmed
      flash[:success] ="#{user.name} confirmado!"
    else
      flash[:alert] = "#{user.name} cancelado!"
    end

    redirect_to activity_participants_path
  end

  def destroy
    registration = Registration.find_by(activity_id: @activity.id,
      user_id: current_user.id)
    registration.destroy

    redirect_to @activity
  end

  private

  def registration_params
    params.permit(:activity_id, :participant_id, :confirmed)
  end

  def set_activity
    @activity = Activity.find(registration_params[:activity_id])
  end
end
