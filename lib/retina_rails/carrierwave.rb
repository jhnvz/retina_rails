module RetinaRails

  module CarrierWave

    extend ActiveSupport::Concern

    included do

      ## Define retina version based on defined versions in the uploader class
      versions.each do |v|

        processors = v[1][:uploader].processors.dup
        dimensions_processor = nil

        ## Check if there's a resize processor to get the dimensions
        processors.each do |p|
          dimensions_processor = processors.delete(p) if p[0].to_s.scan(/resize_to_fill|resize_to_limit|resize_to_fit|resize_and_pad/).any?
        end

        ## Define a retina version if processor is present
        if dimensions_processor

          options = dimensions_processor[1].dup

          width  = options[0] * 2
          height = options[1] * 2

          2.times { options.delete_at(0) }

          options.insert(0, height)
          options.insert(0, width)

          version "#{v[0]}_retina" do
            process dimensions_processor[0] => options

            quality_processor = nil

            ## Set other processors
            processors.each do |processor|
              process processor[0] => processor[1]

              quality_processor = true if processor[0] == :retina_quality
            end

            ## Set default quality if retina_quality is not defined
            process :retina_quality => 40 if quality_processor.nil?
          end

        end

      end

    end

    ## Set the correct filename for storage according to the convention (append @2x to filename)
    def full_filename(for_file)
      super.tap do |file_name|
        file_name.gsub!('.', '@2x.').gsub!('retina_', '') if version_name.to_s.include?('retina')
      end
    end

    ## Set retina image quality
    def retina_quality(percentage)
      if version_name.to_s.include?('retina')
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
    end

  end

end