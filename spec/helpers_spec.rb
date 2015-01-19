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

  describe '#retina_image_tag' do

    context 'with dimensions present' do

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

    context 'without dimensions present' do

      before(:each) { Upload.any_instance.stub(:retina_dimensions).and_return(nil) }

      it 'should set correct width and height' do
        image = helper.retina_image_tag(Upload.new, :avatar, :small, :default => { :width => 25, :height => 40 })

        image.should include('width="25"')
        image.should include('height="40"')

        image = helper.retina_image_tag(Upload.new, :avatar, :small, :default => [25, 40])

        image.should include('width="25"')
        image.should include('height="40"')
      end

      it 'should set no height and width if no defaults present' do
        image = helper.retina_image_tag(Upload.new, :avatar, :small)

        image.should_not include('width')
        image.should_not include('height')
      end

      it 'should be able to add a class' do
        image = helper.retina_image_tag(Upload.new, :avatar, :small, :default => { :width => 25, :height => 40 }, :class => 'foo')

        image.should include('class="foo"')
      end

      it 'should strip default attributes' do
        image = helper.retina_image_tag(Upload.new, :avatar, :small, :default => { :width => 25, :height => 40 })

        image.should_not include('default')
      end

      it 'should respect other options' do
        image = helper.retina_image_tag(Upload.new, :avatar, :small, :default => { :width => 25, :height => 40 }, :alt => 'Some alt tag')

        image.should include('alt="Some alt tag"')
      end

    end

  end

  describe '#image_tag' do

    it 'should show a deprecation warning when used with retina option' do
      ActiveSupport::Deprecation.should_receive(:warn)
        .with("`image_tag('image.png', :retina => true)` is deprecated use `retina_image_tag` instead")

      image_tag('image.png', :retina => true)
    end

    it 'should not show a deprecation warning when used without retina option' do
      ActiveSupport::Deprecation.should_not_receive(:warn)
        .with("`image_tag('image.png', :retina => true)` is deprecated use `retina_image_tag` instead")

      image_tag('image.png')
    end

  end

end
