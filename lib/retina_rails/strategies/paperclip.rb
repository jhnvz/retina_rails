module RetinaRails
  module Strategies
    module Paperclip

      module Base

        extend ActiveSupport::Concern

        module ClassMethods

          def retina!
            serialize :retina_dimensions

            include Uploader
          end

        end # Class methods

      end # Base

      module Uploader

        extend ActiveSupport::Concern

        module ClassMethods

          ##
          # Define an attachment with its options
          #
          # === Parameters
          #
          # [name (#to_sym)] name of the version
          # [options (Hash)] optional options hash
          #
          # === Examples
          #
          #     class Upload
          #
          #       retina!
          #
          #       has_attached_file :image,
          #         :styles => {
          #           :original => ["800x800", :jpg],
          #           :big => ["125x125#", :jpg]
          #         },
          #         :retina => true # Or
          #         :retina => { :quality => 25 } # Optional
          #
          #     end
          #
          def has_attached_file(name, options={})
            super

            optimize_retina! name unless options[:retina] == false
          end

          ##
          # Optimize attachment for retina displays
          #
          # === Parameters
          #
          # [name (Sym)] name of the attachment
          #
          def optimize_retina!(name)
            attachment = attachment_definitions[name]

            ## Check for style definitions
            styles = attachment[:styles]

            retina_options = if attachment[:retina].is_a?(Hash)
              attachment[:retina]
            else
              { :quality => 40 }
            end

            ## Get retina quality
            retina_quality = retina_options[:quality] || 40

            if styles

              retina_styles = {}
              retina_convert_options = {}
              convert_options = attachment[:convert_options]

              ## Iterate over styles and set optimzed dimensions
              styles.each_pair do |key, value|

                dimensions = value.kind_of?(Array) ? value[0] : value

                width  = dimensions.scan(/\d+/)[0].to_i * 2
                height = dimensions.scan(/\d+/)[1].to_i * 2

                processor = dimensions.scan(/#|</).first

                new_dimensions = "#{width}x#{height}#{processor}"
                retina_styles[key.to_sym] = value.kind_of?(Array) ? [new_dimensions, value[1]] : new_dimensions

                ## Set quality convert option
                convert_option = convert_options[key] if convert_options
                convert_option = convert_option ? "#{convert_option} -quality #{retina_quality}" : "-quality #{retina_quality}"
                retina_convert_options[key.to_sym] = convert_option

              end

              ## Override styles with new retina dimensions
              attachment[:styles].merge!(retina_styles)

              ## Set quality convert options
              attachment[:convert_options] = {} if attachment[:convert_options].nil?
              attachment[:convert_options].merge!(retina_convert_options)

              ## Set save dimensions processor
              if attachment[:processors]
                attachment[:processors] << :save_dimensions
                attachment[:processors] << :thumbnail
              else
                attachment[:processors] = [:thumbnail, :save_dimensions]
              end

            end
          end

        end # ClassMethods
      end # Uploader

    end # Paperclip
  end # Strategies
end # RetinaRails

if defined?(::Paperclip)
  module Paperclip
    class SaveDimensions < Paperclip::Processor

      ##
      # Stores the original dimensions of the image as a serialized Hash in to the model
      #
      def make
        model     = attachment.instance
        file_path = file.path rescue nil
        style     = options[:style]

        if file_path
          width, height = `identify -format "%wx%h" #{file_path}`.split(/x/) ## Read dimensions

          ## Set original height and width attributes on model
          model.retina_dimensions = (model.retina_dimensions || {}).deep_merge!(
            attachment.name => {
              style => {
                :width  => width.to_i  / 2,
                :height => height.to_i / 2
              }
            }
          )
        end

        file
      end

    end # SaveDimensions
  end # Paperclip
end
