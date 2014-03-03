module RetinaRails
  module Strategies
    module CarrierWave
      module Base

        extend ActiveSupport::Concern

        module ClassMethods

          def retina!
            include Uploader
          end

        end # ClassMethods

      end # Base

      module Uploader

        extend ActiveSupport::Concern

        module ClassMethods

          ##
          # Adds a new version to this uploader
          #
          # === Parameters
          #
          # [name (#to_sym)] name of the version
          # [options (Hash)] optional options hash
          # [&block (Proc)] a block to eval on this version of the uploader
          #
          # === Examples
          #
          #     class MyUploader < CarrierWave::Uploader::Base
          #
          #       retina!
          #
          #       version :thumb do
          #         process :resize_to_fill => [30, 30]
          #         process :retina_quality => 25
          #       end
          #
          #       version :thumb, :retina => false do
          #         process :resize_to_fill => [30, 30]
          #       end
          #
          #     end
          #
          def version(name, options={}, &block)
            super

            optimize_retina!(name, { :if => options[:if] }) unless options[:retina] == false
          end

          ##
          # Optimize version for retina displays
          #
          # === Parameters
          #
          # [name (Sym)] name of the version
          #
          def optimize_retina!(name, options={})
            config = versions[name]
            options[:retina] = false

            processors = config[:uploader].processors.dup
            dimensions_processor = nil

            ## Check if there's a resize processor to get the dimensions
            processors.each do |p|
              dimensions_processor = processors.delete(p) if p[0].to_s.scan(/resize_to_fill|resize_to_limit|resize_to_fit|resize_and_pad/).any?
            end

            ## Define a retina version if processor is present
            if dimensions_processor

              dimensions = dimensions_processor[1].dup

              width  = dimensions[0] * 2
              height = dimensions[1] * 2

              2.times { dimensions.delete_at(0) }

              dimensions.insert(0, height)
              dimensions.insert(0, width)

              ## Override version with double height and width
              version name, :retina => false do
                process dimensions_processor[0] => dimensions

                quality_processor = nil

                ## Set other processors
                processors.each do |processor|
                  process processor[0] => processor[1]

                  quality_processor = true if processor[0] == :retina_quality
                end

                ## Set default quality if retina_quality is not defined
                process :retina_quality => 40 if quality_processor.nil?

                ## Store dimensions
                process :store_retina_dimensions
              end
            end
          end

        end # ClassMethods

        ##
        # Stores the original dimensions of the image as a serialized Hash in to the model
        #
        def store_retina_dimensions
          if model
            model.class.serialize :retina_dimensions ## Serialize dimensions on model

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

      end # Uploader
    end # CarrierWave
  end # Strategies
end # RetinaRails
