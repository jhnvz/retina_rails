require 'spec_helper'

class AnonymousUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  version :small do
    process :resize_to_fill => [30, 30]
    process :retina_quality => 20
  end

  version :small_without_quality do
    process :resize_to_fill => [30, 30]
  end

  version :small_without_dimensions do
    process :desaturate
  end

  version :small_multiple_processors do
    process :resize_to_fill => [30, 30]
    process :desaturate
  end

  def desaturate
    manipulate! do |img|
      img = img.quantize 256, Magick::GRAYColorspace
    end
  end

  version :small_without_processor

  include RetinaRails::CarrierWave

end

class CarrierWaveUpload

  extend CarrierWave::Mount

  attr_accessor :avatar
  attr_accessor :id

  mount_uploader :avatar, AnonymousUploader

  def initialize
    self.id = 999
  end

end

describe RetinaRails::CarrierWave do

  include CarrierWave::Test::Matchers

  subject { AnonymousUploader }

  before do
    AnonymousUploader.enable_processing = true
    @uploader = AnonymousUploader.new(CarrierWaveUpload.new, :avatar)
    @uploader.store!(File.open("#{File.dirname(__FILE__)}/fixtures/images/avatar.jpeg"))
  end

  after do
    AnonymousUploader.enable_processing = false
    @uploader.remove!
  end

  context 'with dimensions processor' do

    its(:versions) { should include :small_retina }

    it { @uploader.small.should have_dimensions(30, 30) }
    it { @uploader.small_retina.should have_dimensions(60, 60) }

    it { File.basename(@uploader.small.current_path, 'jpeg').should include 'small_'}

    it { File.basename(@uploader.small_retina.current_path, 'jpeg').should include '@2x'}
    it { File.basename(@uploader.small_retina.current_path, 'jpeg').should_not include 'retina_'}

  end

  context 'with quality processor' do

    it { Magick::Image.read(@uploader.small.current_path).first.quality.should == 84 }

    it { Magick::Image.read(@uploader.small_retina.current_path).first.quality.should == 20 }

  end

  context 'without quality processor' do

    it { Magick::Image.read(@uploader.small_without_quality.current_path).first.quality.should == 84 }

    it { Magick::Image.read(@uploader.small_without_quality_retina.current_path).first.quality.should == 40 }

  end

  context 'without dimensions processor' do

    its(:versions) { should_not include :small_without_dimensions_retina }

  end

  context 'with multiple processors' do

    its(:versions) { should include :small_multiple_processors_retina }

    it { subject.versions[:small_multiple_processors][:uploader].processors.should include([:desaturate, [], nil]) }

    it { @uploader.small_multiple_processors.should have_dimensions(30, 30) }
    it { @uploader.small_multiple_processors_retina.should have_dimensions(60, 60) }

    it { File.basename(@uploader.small_multiple_processors.current_path, 'jpeg').should include 'small_'}

    it { File.basename(@uploader.small_multiple_processors_retina.current_path, 'jpeg').should include '@2x'}
    it { File.basename(@uploader.small_multiple_processors_retina.current_path, 'jpeg').should_not include 'retina_'}

  end

  context 'without processor' do

    its(:versions) { should include :small_without_processor }
    its(:versions) { should_not include :small_without_processor_retina }

  end

end