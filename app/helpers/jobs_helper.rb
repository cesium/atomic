require "redcarpet/render_strip"

module JobsHelper
  def can_create?
    can? :create, Job
  end

  def error_messages(job)
    job.errors.full_messages
  end
end
