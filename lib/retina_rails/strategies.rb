module RetinaRails
  module Strategies

    def self.include_strategies
      if defined?(::CarrierWave)
        require 'retina_rails/strategies/carrierwave'
        ::CarrierWave::Uploader::Base.send(:include, CarrierWave::Base)
      end
      if defined?(::Paperclip)
        require 'retina_rails/strategies/paperclip'
        ::ActiveRecord::Base.send(:include, Paperclip::Base)
      end
    end

  end # Strategies
end # RetinaRails
