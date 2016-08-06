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
end
