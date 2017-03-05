class Activities::RegistrationsController < ApplicationController
  before_action :set_activity, only: [:create]
  load_and_authorize_resource

  def create
    unless @activity.registered?(current_user)
      registration = Registration.create(activity_id: @activity.id, user_id: current_user.id)
    end
    redirect_to @activity
  end

  private

  def activity_params
    params.permit(:id)
  end

  def set_activity
    @activity = Activity.find(params[:id])
  end
end
