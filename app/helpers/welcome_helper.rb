module WelcomeHelper
  def carousel_image_tag(file, data = {}, **args)
    default_data = {
      bgfit: 'cover',
      bgposition: 'center',
      bgrepeat: 'no-repeat'
    }.merge(data)
    (args[:data] && args[:data].reverse_merge!(default_data)) || args[:data] = default_data
    image_tag(file, args)
  end

  def slider_caption_title(start_second:, x:, y:, title:)
    content_tag(
      :div,
      "#{title}",
      class: ["caption", "left-tile-text", "sfr", "tp-resizeme", "tp-caption start"],
      data: { end: 9400, endspeed: 600, speed: 600, start: start_second, x: x, y: y }
    )
  end

  def slider_check(start_second:, x:, y:)
    content_tag(
      :div,
      content_tag(:i, "", class: ["fa", "fa-check"]),
      class: ["caption", "medium_bg_darkblue", "sfl", "medium", "tp-resizeme"],
      data: { end: 9400, endspeed: 600, speed: 600, start: start_second, x: x, y: y }
    )
  end

  def slider_caption(start_second:, x:, y:, caption:)
    content_tag(
      :div,
      "#{caption}",
      class: ["caption", "modern_big_redbg", "sfb", "medium", "tp-resizeme"],
      data: { end: 9400, endspeed: 600, speed: 600, start: start_second, x: x, y: y }
    )
  end

  def partner(image_file:, link:, alt:)
    content_tag(
      :div,
      link_to(link, target: "_blank") do
        image_tag(image_file, alt: alt, class: "img-responsive")
      end,
      class: "item",
    )
  end
end
