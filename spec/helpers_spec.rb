require 'spec_helper'

class Image

  def url(version)
    '/some_image.png'
  end

end

class Upload

  attr_accessor :avatar

  def initialize
    self.avatar = Image.new
  end

  def retina_dimensions
    {
      :avatar => {
        :small => {
          :width  => 40,
          :height => 30
        }
      }
    }
  end

end

describe ActionView::Helpers::AssetTagHelper, :type => :helper do

  subject { helper }

  describe :retina_image_tag do

    it 'should set correct width and height' do
      image = helper.retina_image_tag(Upload.new, :avatar, :small)

      image.should include('width="40"')
      image.should include('height="30"')
    end

    it 'should be able to add a class' do
      image = helper.retina_image_tag(Upload.new, :avatar, :small, :class => 'foo')
      image.should include('class="foo"')
    end

  end

end