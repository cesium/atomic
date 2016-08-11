module WelcomeHelper
  def carousel_image_tag(file, data = {}, **args)
    data = {
      bgfit: 'cover',
      bgposition: 'center',
      bgrepeat: 'no-repeat'
    }.merge(data)
    image_tag(file, args.merge({data: data}))
  end
end
