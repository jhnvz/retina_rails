require 'retina_rails/extensions/paperclip'
require 'retina_rails/extensions/carrierwave'

module RetinaRails
  module Extensions

    def self.include_extensions
      if defined?(::CarrierWave)
        ::CarrierWave::Mount.include CarrierWave::Mount
      end
      if defined?(::Paperclip)
        ::Paperclip::Style.include Paperclip::Style
      end
    end

  end # Extensions
end # RetinaRails
