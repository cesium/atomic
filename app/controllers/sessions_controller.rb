class SessionsController < ApplicationController
  authorize_resource class: false

  def create
    return unless request.env["omniauth.auth"]

    user = User.from_omniauth(request.env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end
