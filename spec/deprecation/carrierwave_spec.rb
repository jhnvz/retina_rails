require 'spec_helper'

describe RetinaRails::CarrierWave do

  it 'should raise a deprection error when included the old way' do
    expect do
      class DeprecatedUploader < CarrierWave::Uploader::Base
        include RetinaRails::CarrierWave
      end
    end.to raise_error(RetinaRails::DeprecationError)
  end

end