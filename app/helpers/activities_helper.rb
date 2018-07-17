require "redcarpet/render_strip"

module ActivitiesHelper
  def next_activities_button
    theme = params[:show] != "previous" ? "border-theme-highlighted" : "border-theme"
    "btn " + theme
  end

  def previous_activities_button
    theme = params[:show] == "previous" ? "border-theme-highlighted" : "border-theme"
    "btn " + theme
  end

  def can_cancel_registratation?(activity)
    registration = activity.registrations.build
    can?(:destroy, registration) && activity.registered?(current_user)
  end

  def can_registrate?(activity)
    registration = @activity.registrations.build
    can?(:create, registration) && !activity.registered?(current_user)
  end

  def activity_link(activity)
    if !activity.external_link.empty?
      activity.external_link
    elsif current_user.nil?
      sign_in_path
    else
      activity_registration_path(activity)
    end
  end

  def can_create?
    can? :create, Activity
  end

  def error_messages(activity)
    activity.errors.full_messages
  end

  def registrable(activity)
    activity.allows_registrations && (current_user.nil? || can_registrate?(activity))
  end
end
