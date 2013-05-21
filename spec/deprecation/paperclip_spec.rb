require 'spec_helper'

describe RetinaRails::Paperclip do

  it 'should raise a deprection error when included the old way' do
    expect do
      class PaperclipUpload < ActiveRecord::Base
        include RetinaRails::Paperclip
      end
    end.to raise_error(RetinaRails::DeprecationError)
  end

end

