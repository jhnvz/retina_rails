require 'spec_helper'

describe RetinaRails::Strategies::Paperclip do

  ##
  # Store image so we can run tests against it
  #
  def upload!
    @upload = PaperclipUpload.new(:avatar => File.open("#{fixture_path}/images/avatar.jpeg"))
    @upload.save
  end

  ##
  # Return image path so we can open image
  #
  def image_path
    "#{File.dirname(__FILE__).gsub('spec/strategies', 'public')}#{@upload.avatar.url(:big)}"
  end

  ##
  # Make sure image get's destroyed after each test
  #
  after(:each) do
    @upload.destroy if @upload
  end

  context 'defaults' do

    before(:each) do
      PaperclipUpload.class_eval do
        has_attached_file :avatar,
          :styles => {
             :big      => ["30x40#", :jpg],
             :original => ["800x800", :jpg]
           }
      end
      upload!
    end

    it 'should double the height and width of an image' do
      Paperclip::Geometry.from_file(image_path).to_s.should == '60x80'
    end

    it 'should store original width and height attributes for version' do
      @upload.retina_dimensions[:avatar][:big].should == { :width => 30, :height => 40 }
    end

    it "should set quality to it's default 40%" do
      quality = Magick::Image.read(image_path).first.quality
      quality.should == 40
    end

  end

  context 'file without extension name' do

    it 'should not fail' do
      stream  = FileStringIO.new('avatar', File.read("#{fixture_path}/images/avatar.jpeg"))
      @upload = PaperclipUpload.create(:avatar => stream)
    end

  end

  context 'with string styles' do

    before(:each) do
      PaperclipUpload.class_eval do
        has_attached_file :avatar,
          :styles => {
             :big      => "30x40#",
             :original => "800x800"
           }
      end
      upload!
    end

    it 'should double the height and width of an image' do
      Paperclip::Geometry.from_file(image_path).to_s.should == '60x80'
    end

    it 'should store original width and height attributes for version' do
      @upload.retina_dimensions[:avatar][:big].should == { :width => 30, :height => 40 }
    end

    it "should set quality to it's default 40%" do
      quality = Magick::Image.read(image_path).first.quality
      quality.should == 40
    end

  end

  context 'override quality' do

    before(:each) do
      PaperclipUpload.class_eval do
        has_attached_file :avatar,
          :styles => {
             :big      => ["30x40#", :jpg],
             :original => ["800x800", :jpg]
           },
           :retina => { :quality => 25 }
      end
      upload!
    end

    it "should set quality to it's default 40%" do
      quality = Magick::Image.read(image_path).first.quality
      quality.should == 25
    end

  end

end
