require 'spec_helper'

ROOT = File.dirname(__FILE__)

class PaperclipUpload < ActiveRecord::Base

  retina!

  has_attached_file :avatar,
    :styles => {
       :original => ["800x800", :jpg],
       :big => ["125x125#", :jpg]
     },
     :retina => { :quality => 60 },
     :path => "#{ROOT}/:class/:id/:basename_:style.:extension",
     :url => "#{ROOT}/:class/:id/:basename_:style.:extension"

  has_attached_file :avatar_without_quality,
    :styles => {
       :original => ["800x800", :jpg],
       :big => ["125x125#", :jpg]
     },
     :retina => true,
     :path => "#{ROOT}/:class/:id/:basename_:style.:extension",
     :url => "#{ROOT}/:class/:id/:basename_:style.:extension"

end

describe RetinaRails::Strategies::Paperclip do

  subject { PaperclipUpload }

  context 'overriding options' do

    it { subject.attachment_definitions[:avatar][:styles][:original_retina].should == ['1600x1600', :jpg] }
    it { subject.attachment_definitions[:avatar][:styles][:big_retina].should == ['250x250#', :jpg] }

    it { subject.attachment_definitions[:avatar][:path].should == "#{ROOT}/:class/:id/:basename_:style:retina.:extension" }
    it { subject.attachment_definitions[:avatar][:url].should == "#{ROOT}/:class/:id/:basename_:style:retina.:extension" }

  end

  context 'uploads' do

    subject { PaperclipUpload.create(:avatar => File.open("#{fixture_path}/images/avatar.jpeg")) }

    it { subject.avatar.url(:big).should == "#{ROOT}/paperclip_uploads/1/avatar_big.jpg" }
    it { subject.avatar.url(:big_retina).should == "#{ROOT}/paperclip_uploads/2/avatar_big@2x.jpg" }

    it { Paperclip::Geometry.from_file(subject.avatar.url(:big)).to_s.should == '125x125' }
    it { Paperclip::Geometry.from_file(subject.avatar.url(:big_retina)).to_s.should == '250x250' }

  end

  context 'with retina quality' do

    subject { PaperclipUpload.create(:avatar => File.open("#{fixture_path}/images/avatar.jpeg")) }

    it { Magick::Image.read(subject.avatar.url(:big)).first.quality.should == 84 }
    it { Magick::Image.read(subject.avatar.url(:big_retina)).first.quality.should == 60 }

  end

  context 'without retina quality' do

    subject { PaperclipUpload.create(:avatar_without_quality => File.open("#{fixture_path}/images/avatar.jpeg")) }

    it { Magick::Image.read(subject.avatar_without_quality.url(:big)).first.quality.should == 84 }
    it { Magick::Image.read(subject.avatar_without_quality.url(:big_retina)).first.quality.should == 40 }

  end

  describe :optimze_path do

    subject { RetinaRails::Strategies::Paperclip::Uploader::Extensions }

    it { subject.optimize_path('/:filename').should == '/:basename:retina.:extension' }

    it { subject.optimize_path('/:basename.:extension').should == '/:basename:retina.:extension' }

  end

  describe :override_default_options do

    context 'Paperclip default' do

      before { RetinaRails::Strategies::Paperclip::Uploader::Extensions.override_default_options }

      it { Paperclip::Attachment.default_options[:url].should == '/system/:class/:attachment/:id_partition/:style/:basename:retina.:extension' }

    end

    context 'User defined paperclip default' do

      before do

        Paperclip::Attachment.default_options[:url] = '/:class/:attachment/:id/:style/:basename.:extension'
        RetinaRails::Strategies::Paperclip::Uploader::Extensions.override_default_options

      end

      it { Paperclip::Attachment.default_options[:url].should == '/:class/:attachment/:id/:style/:basename:retina.:extension' }

    end

  end

end
