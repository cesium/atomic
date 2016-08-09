module WelcomeHelper
  def carousel_image_tag file
    image_tag file, :data => { :bgfit => 'cover', :bgposition => 'center', :bgrepeat => 'no-repeat' }
  end
end
