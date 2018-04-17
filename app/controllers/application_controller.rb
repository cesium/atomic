class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include CanCan::ControllerAdditions
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def not_found
    render file: "#{Rails.root}/public/404", layout: false, status: :not_found
  end
end
