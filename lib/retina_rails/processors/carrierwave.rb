module RetinaRails
  module Processors
    module CarrierWave

      extend ActiveSupport::Concern

      ##
      # Stores the original dimensions of the image as a serialized Hash in to the model
      #
      def store_retina_dimensions
        if model
          width, height = `identify -format "%wx%h" #{file.path}`.split(/x/) ## Read dimensions

          ## Set original height and width attributes on model

          model.retina_dimensions = (model.retina_dimensions.try(:value) || {}).deep_merge!(
            mounted_as => {
              version_name => {
                :width  => width.to_i  / 2,
                :height => height.to_i / 2
              }
            }
          )
        end
      end

      ##
      # Process retina quality of the image.
      # Works with ImageMagick and MiniMagick
      #
      # === Parameters
      #
      # [percentage (Int)] quality in percentage
      #
      def retina_quality(percentage)
        manipulate! do |img|
          if defined?(Magick)
            img.write(current_path) { self.quality = percentage } unless img.quality == percentage
          elsif defined?(MiniMagick)
            img.quality(percentage.to_s)
          end
          img = yield(img) if block_given?
          img
        end
      end

    end # CarrierWave
  end # Processors
end # RetinaRails
