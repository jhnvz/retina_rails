require 'spec_helper'

describe ActionView::Helpers::AssetTagHelper, :type => :helper do

  class SomeWrapperClassForUrl
    def to_s
      'image.png'
    end
  end

  subject { helper }

  describe :image_tag do

    context 'with retina option' do

      it { subject.image_tag('image.png', :retina => true).should == '<img alt="Image" data-at2x="/assets/image@2x-0842b16379ded9ddcc299912621f76bc.png" src="/assets/image-e8de7f87c2b9d08490575267a4c9eddc.png" />' }

      it { subject.image_tag('image.some.png', :retina => true).should == '<img alt="Image.some" data-at2x="/assets/image.some@2x-0842b16379ded9ddcc299912621f76bc.png" src="/assets/image.some-e8de7f87c2b9d08490575267a4c9eddc.png" />' }

      context 'with class' do

        it { subject.image_tag(SomeWrapperClassForUrl.new, :retina => true).should == '<img alt="Image" data-at2x="/assets/image@2x-0842b16379ded9ddcc299912621f76bc.png" src="/assets/image-e8de7f87c2b9d08490575267a4c9eddc.png" />' }

      end

    end

    context 'without retina' do

      it { subject.image_tag('image.png').should == '<img alt="Image" src="/assets/image-e8de7f87c2b9d08490575267a4c9eddc.png" />' }

    end

  end

end