class Activities::RegistrationsController < ApplicationController
  before_action :set_activity
  load_and_authorize_resource

  def create
    begin
      @activity.user_registration(current_user)
    rescue ActiveRecord::RecordInvalid
      flash[:alert] = "O utilizador não pode ser registado nesta atividade!"
    end

    redirect_to @activity
  end

  def index
    @registrations = @activity.registrations.sort_by { |r| r.user.name }
  end

  def update
    begin
      msg_type, message = @activity
        .user_registration_update(registration_params[:participant_id], params[:confirmed])
      flash[msg_type] = message
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "O utilizador selecionado já não se encontra registado nesta atividade!"
    end

    redirect_to activity_participants_path
  end

  def destroy
    begin
      @activity.user_deregistration(current_user)
    rescue ActiveRecord::RecordInvalid
      flash[:alert] = "O utilizador não pode ser eliminado desta atividade!"
    end

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
