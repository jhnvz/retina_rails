require 'spec_helper'

class PaperclipUpload < ActiveRecord::Base

  has_attached_file :avatar,
    :styles => {
       :original => ["800x800", :jpg],
       :big => ["125x125#", :jpg]
     },
     :path => "#{File.dirname(__FILE__)}/:class/:id/:basename_:style.:extension",
     :url => "#{File.dirname(__FILE__)}/:class/:id/:basename_:style.:extension"

  include RetinaRails::Paperclip

end

describe RetinaRails::Paperclip do

  subject { PaperclipUpload }

  context 'overriding options' do

    it { subject.attachment_definitions[:avatar][:styles][:original_retina].should == ['1600x1600', :jpg] }
    it { subject.attachment_definitions[:avatar][:styles][:big_retina].should == ['250x250#', :jpg] }

    it { subject.attachment_definitions[:avatar][:path].should == "#{File.dirname(__FILE__)}/:class/:id/:basename_:style:retina.:extension" }
    it { subject.attachment_definitions[:avatar][:url].should == "#{File.dirname(__FILE__)}/:class/:id/:basename_:style:retina.:extension" }

  end

  context 'uploads' do

    subject { PaperclipUpload.create(:avatar => File.open("#{File.dirname(__FILE__)}/fixtures/images/avatar.jpeg")) }

    it { subject.avatar.url(:big).should == "#{File.dirname(__FILE__)}/paperclip_uploads/1/avatar_big.jpg" }
    it { subject.avatar.url(:big_retina).should == "#{File.dirname(__FILE__)}/paperclip_uploads/2/avatar_big@2x.jpg" }

    it { Paperclip::Geometry.from_file(subject.avatar.url(:big)).to_s.should == '125x125' }
    it { Paperclip::Geometry.from_file(subject.avatar.url(:big_retina)).to_s.should == '250x250' }

    it "should raise an understandable exception when attachments are misconfigured" do
      expect do
        class PaperclipUploadMisconfigured < ActiveRecord::Base

          has_attached_file :avatar,
            :styles => {
               :original => "800x800",
               :big => "125x125#"
             },
             :path => "#{File.dirname(__FILE__)}/:class/:id/:basename_:style.:extension",
             :url => "#{File.dirname(__FILE__)}/:class/:id/:basename_:style.:extension"

          include RetinaRails::Paperclip

        end
      end.to raise_error(RetinaRails::Paperclip::MISCONFIGURATION_ERROR)
    end

  end

end
