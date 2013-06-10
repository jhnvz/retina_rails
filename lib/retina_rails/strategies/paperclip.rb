module RetinaRails
  module Strategies
    module Paperclip

      module Base

        extend ActiveSupport::Concern

        module ClassMethods

          def retina!
            include Uploader
          end

        end

      end

      module Uploader

        extend ActiveSupport::Concern

        included do

          ## Override paperclip default options
          Extensions.override_default_options

        end

        module ClassMethods

          def has_attached_file(name, options={})
            super

            has_attached_retina_file name if options[:retina]
          end

          def has_attached_retina_file(name)
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


=begin
              #for those who define paperclip styles as this:- 
              has_mongoid_attached_file :attachment, :styles => {
                :small        => {:geometry => "75x75>"},
                :masonry_size => {:geometry => "220x145"},
                :thumbnail_size => {:geometry => "240x240>", :processors => [:jcropper]}
              }
=end

                dimensions = value[0]
                
                dimensions = value.values.first if dimensions.nil? #added to avoid further errors for those who define styles in model differently

                width  = dimensions.scan(/\d+/)[0].to_i * 2
                height = dimensions.scan(/\d+/)[1].to_i * 2

                processor = dimensions.scan(/#|</).first

                retina_styles["#{key}_retina".to_sym] = ["#{width}x#{height}#{processor}", value[1]]

                ## Set quality convert option
                convert_option = convert_options[key] if convert_options
                convert_option = convert_option ? "#{convert_option} -quality #{retina_quality}" : "-quality #{retina_quality}"
                retina_convert_options["#{key}_retina".to_sym] = convert_option

              end

              ## Append new retina optimzed styles
              attachment[:styles].merge!(retina_styles)

              ## Set quality convert options
              attachment[:convert_options] = {} if attachment[:convert_options].nil?
              attachment[:convert_options].merge!(retina_convert_options)

              ## Make path work with retina optimization
              original_path = attachment[:path]
              attachment[:path] = Extensions.optimize_path(original_path) if original_path

              ## Make url work with retina optimization
              original_url = attachment[:url]
              attachment[:url] = Extensions.optimize_path(original_url) if original_url

            end
          end

        end

        module Extensions

          ## Insert :retina interpolation in url or path
          def self.optimize_path(path)
            path.scan(':retina').empty? ? path.gsub(':filename', ':basename.:extension').split('.').insert(-2, ':retina.').join : path
          end

          def self.override_default_options

            ## Remove _retina from style so it doesn't end up in filename
            ::Paperclip.interpolates :style do |attachment, style|
              style.to_s.end_with?('_retina') ? style.to_s[0..-8] : style
            end

            ## Replace :retina with @2x if style ends with _retina
            ::Paperclip.interpolates :retina do |attachment, style|
              style.to_s.end_with?('_retina') ? '@2x' : ''
            end

            ## Make default url compatible with retina optimzer
            url = ::Paperclip::Attachment.default_options[:url]
            ::Paperclip::Attachment.default_options[:url] = optimize_path(url)

          end

        end

      end

    end
  end
end
