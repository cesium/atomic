require 'redcarpet'
require 'redcarpet/render_strip'

module ActivitiesHelper
  def can_cancel_registratation?(activity)
    registration = activity.registrations.build
    can?(:destroy, registration) && activity.registered?(current_user)
  end

  def can_registrate?(activity)
    registration = @activity.registrations.build
    can?(:create, registration) && !activity.registered?(current_user)
  end

  def can_create?
    can? :create, Activity
  end

  def error_messages(activity)
    activity.errors.full_messages
  end

  def markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML,
        no_intra_emphasis: true,
        fenced_code_blocks: true,
        disable_indented_code_blocks: true,
        autolink: true)
    markdown.render(text).html_safe
  end

  def plaintext(markdown)
    plaintext = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
    plaintext.render(markdown)
  end
end
