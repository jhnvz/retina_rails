require 'spec_helper'

describe RetinaRails::Strategies::CarrierWave do

  include CarrierWave::Test::Matchers

  ##
  # Store image so we can run tests against it
  #
  def upload!
    AnonymousUploader.enable_processing = true
    @uploader = AnonymousUploader.new(CarrierWaveUpload.new, :avatar)
    @uploader.store!(File.open("#{fixture_path}/images/avatar.jpeg"))
  end

  ##
  # Remove image after testing
  #
  after(:each) do
    AnonymousUploader.enable_processing = false
    @uploader.remove!
    AnonymousUploader.versions[:small][:uploader].processors = [] ## Reset processors
  end

  ##
  # Actual tests
  #
  context 'with dimensions processor' do

    ##
    # Setup Anonymous uploader with a resize processor
    #
    before(:each) do
      AnonymousUploader.class_eval do
        version :small do
          process :resize_to_fill => [30, 40]
        end
      end
      upload!
    end

    it 'should double the height and width of an image' do
      @uploader.small.should have_dimensions(60, 80)
    end

    it 'should store original width and height attributes for version' do
      @uploader.model.retina_dimensions.value[:avatar][:small].should == { :width => 30, :height => 40 }
    end

    it "should set quality to it's default 40%" do
      quality = Magick::Image.read(@uploader.small.current_path).first.quality
      quality.should == 40
    end

  end

  context 'override quality' do

    ##
    # Setup Anonymous uploader with a resize processor and override quality
    #
    before(:each) do
      AnonymousUploader.class_eval do
        version :small do
          process :resize_to_fill => [30, 40]
          process :retina_quality => 60
        end
      end
      upload!
    end

    it "should override quality" do
      quality = Magick::Image.read(@uploader.small.current_path).first.quality
      quality.should == 60
    end

  end

  context 'multiple processors' do

    ##
    # Setup Anonymous uploader with a custom processor
    #
    before(:each) do
      AnonymousUploader.class_eval do
        version :small do
          process :resize_to_fill => [30, 40]
          process :desaturate
        end

        def desaturate
          manipulate! do |img|
            img = img.quantize 256, Magick::GRAYColorspace
          end
        end
      end

      upload!
    end

    it 'should double the height and width of an image' do
      @uploader.small.should have_dimensions(60, 80)
    end

    it 'should store original width and height attributes for version' do
      @uploader.model.retina_dimensions.value[:avatar][:small].should == { :width => 30, :height => 40 }
    end

  end

  context 'with failing conditional version' do

    ##
    # Setup Anonymous uploader with a failing condition
    #
    before(:each) do
      AnonymousUploader.class_eval do
        version :small_conditional, :if => ->(img, opts) { false } do
          process :resize_to_fill => [30, 30]
        end
      end

      upload!
    end

    it 'should not create a version' do
      @uploader.version_exists?(:small_conditional).should be_false
      @uploader.small_conditional.current_path.should_not be_present
    end

  end

end
