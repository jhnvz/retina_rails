module RetinaRails

  module CarrierWave

    extend ActiveSupport::Concern

    module ClassMethods

      def raise_depraction_error!
        raise RetinaRails::DeprecationError.new("As of version 1.0.0.beta1 activating RetinaRails by including `RetinaRails::Carrierwave` is depracted. Add `retina!` to your uploader instead.")
      end

    end

    included do

      raise_depraction_error!

    end

  end

end