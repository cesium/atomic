require "redcarpet/render_strip"

module JobsHelper
  def can_create?
    can? :create, Job
  end

  def error_messages(job)
    job.errors.full_messages
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
