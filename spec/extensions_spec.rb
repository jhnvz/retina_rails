describe RetinaRails::Extensions do

  describe :optimze_path do

    subject { RetinaRails::Extensions }

    it { subject.optimize_path('/:filename').should == '/:basename:retina.:extensions' }

    it { subject.optimize_path('/:basename.:extensions').should == '/:basename:retina.:extensions' }

  end

  describe :override_default_options do

    context 'Paperclip default' do

      before { RetinaRails::Extensions.override_default_options }

      it { Paperclip::Attachment.default_options[:url].should == '/system/:class/:attachment/:id_partition/:style/:basename:retina.:extensions' }

    end

    context 'User defined paperclip default' do

      before do

        Paperclip::Attachment.default_options[:url] = '/:class/:attachment/:id/:style/:basename.:extensions'
        RetinaRails::Extensions.override_default_options

      end

      it { Paperclip::Attachment.default_options[:url].should == '/:class/:attachment/:id/:style/:basename:retina.:extensions' }

    end

  end

end