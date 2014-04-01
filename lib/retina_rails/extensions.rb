module RetinaRails
  module Extensions

    def self.include_extensions
      if defined?(::CarrierWave)
        require 'retina_rails/extensions/carrierwave'
        ::CarrierWave::Mount.send(:include, CarrierWave::Mount)
      end
      if defined?(::Paperclip)
        require 'retina_rails/extensions/paperclip'
        ::Paperclip::Style.send(:include, Paperclip::Style)
      end
    end

  end # Extensions
end # RetinaRails
