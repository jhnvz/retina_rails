module RetinaRails
  module Processors

    def self.include_processors
      if defined?(::CarrierWave)
        require 'retina_rails/processors/carrierwave'
      end
      if defined?(::Paperclip)
        require 'retina_rails/processors/paperclip'
      end
    end

  end # Processors
end # RetinaRails
