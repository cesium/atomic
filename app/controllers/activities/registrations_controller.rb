class Activities::RegistrationsController < ApplicationController
  before_action :set_activity
  load_and_authorize_resource

  def create
    @activity.user_registration(current_user)
    redirect_to @activity
  end

  def index
    @registrations = @activity.registrations.sort_by { |r| r.user.name }
  end

  def update
    registration = @activity.registrations .find_by(user_id: registration_params[:participant_id])

    if registration.nil?
      flash[:alert] = "O utilizador selecionado já não se encontra registado nesta atividade!"
    else
      msg_type, message = registration.toggle_confirmation(params[:confirmed])
      flash[msg_type] = message
    end

    redirect_to activity_participants_path
  end

  def destroy
    registration = Registration
      .find_by(activity_id: @activity.id, user_id: current_user.id)

    registration&.destroy
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
