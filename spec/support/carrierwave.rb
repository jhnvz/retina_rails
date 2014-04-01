class AnonymousUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  retina!

end

class CarrierWaveUpload < ActiveRecord::Base

  extend CarrierWave::Mount

  mount_uploader :avatar, AnonymousUploader

end
