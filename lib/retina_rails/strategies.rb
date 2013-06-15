require 'retina_rails/strategies/carrierwave'
require 'retina_rails/strategies/paperclip'

module RetinaRails
  module Strategies

    def self.include_strategies
      if defined?(::CarrierWave)
        ::CarrierWave::Uploader::Base.send(:include, RetinaRails::Strategies::CarrierWave::Base)
      end
      if defined?(Mongoid::Paperclip)
        ::Mongoid::Document.send(:include, RetinaRails::Strategies::Paperclip::Base)
      end
      if defined?(::Paperclip) and defined?(::ActiveRecord)
        ::ActiveRecord::Base.send(:include, RetinaRails::Strategies::Paperclip::Base)
      end
    end

  end
end
