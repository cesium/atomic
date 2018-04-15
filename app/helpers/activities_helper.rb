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
    if current_user.nil?
      sign_in_path
    elsif activity.external_link.empty?
      activity_registration_path(@activity)
    else
      @activity.external_link
    end
  end

  def can_create?
    can? :create, Activity
  end

  def error_messages(activity)
    activity.errors.full_messages
  end

  def to_markdown(text)
    Redcarpet::Markdown
      .new(Redcarpet::Render::HTML, markdown_config)
      .render(text)
      .html_safe
  end

  def markdown_config
    {
      no_intra_emphasis: true,
      fenced_code_blocks: true,
      disable_indented_code_blocks: true,
      autolink: true
    }
  end

  def to_plaintext(markdown)
    Redcarpet::Markdown
      .new(Redcarpet::Render::StripDown)
      .render(markdown)
  end
end
