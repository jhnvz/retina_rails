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

    ## Reset processors
    version = AnonymousUploader.versions[:small]
    if version.respond_to?(:processors)
      version.processors = []
    else
      version[:uploader].processors = []
    end
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
      expect(@uploader.small).to have_dimensions(60, 80)
    end

    it 'should store original width and height attributes for version' do
      expect(@uploader.model.retina_dimensions[:avatar][:small]).to eq({ :width => 30, :height => 40 })
    end

    it "should set quality to it's default 60%" do
      quality = Magick::Image.read(@uploader.small.current_path).first.quality
      expect(quality).to eq(60)
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
          process :retina_quality => 80
        end
      end
    end

    it "should override quality" do
      upload!
      quality = Magick::Image.read(@uploader.small.current_path).first.quality
      expect(quality).to eq 80
    end

    it 'should receive quality processor once' do
      expect_any_instance_of(AnonymousUploader).to receive(:retina_quality).once

      upload!
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
      expect(@uploader.small).to have_dimensions(60, 80)
    end

    it 'should store original width and height attributes for version' do
      expect(@uploader.model.retina_dimensions[:avatar][:small]).to eq({ :width => 30, :height => 40 })
    end

  end

  context 'with custom resize processor' do

    ##
    # Setup Anonymous uploader with a custom resize processor
    #
    before(:each) do
      AnonymousUploader.class_eval do
        version :small, :retina => false do
          process :custom_resize => [200, 200]
          process :store_retina_dimensions
        end

        def custom_resize(width, height)
          manipulate! do |img|
            img.resize_to_fill!(width, height)
          end
        end
      end

      upload!
    end

    it 'should double the height and width of an image' do
      expect(@uploader.small).to have_dimensions(200, 200)
    end

    it 'should store original width and height attributes for version' do
      expect(@uploader.model.retina_dimensions[:avatar][:small]).to eq({ :width => 100, :height => 100 })
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
      expect(@uploader.version_exists?(:small_conditional)).to eq(false)
      expect(@uploader.small_conditional.current_path).to_not be_present
    end

  end

end
