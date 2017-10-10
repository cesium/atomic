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
    @registrations = @activity.registrations
  end

  def update
    user = User.find(registration_params[:participant_id])
    registration = @activity.registrations.find_by(user_id: user.id)

    if registration.nil?
      flash[:alert] = "#{user.name} não se encontra registado nesta atividade!"
      redirect_to activity_participants_path
    end

    confirmed = params[:confirmed] == "true"
    registration.update_attribute(:confirmed, !confirmed)

    if confirmed 
      flash[:alert] = "Confirmação de #{user.name} cancelada!"
    else
      flash[:success] = "#{user.name} confirmado!"
    end

    redirect_to activity_participants_path
  end

  def destroy
    registration = Registration
      .find_by(activity_id: @activity.id, user_id: current_user.id)

    registration.destroy unless registration.nil?
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
