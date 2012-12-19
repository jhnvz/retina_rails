module RetinaRails

  module CarrierWave

    extend ActiveSupport::Concern

    included do

      ## Define retina version based on defined versions in the uploader class
      versions.each do |v|

        processor = nil

        ## Check if there's a resize processor to get the dimensions
        v[1][:uploader].processors.each do |p|
          processor = p if p[0].to_s.scan(/resize_to_fill|resize_to_limit|resize_to_fit|resize_and_pad/).any?
        end

        ## Define a retina version if processor is present
        if processor

          options = processor[1].dup

          width  = options[0] * 2
          height = options[1] * 2

          2.times { options.delete_at(0) }

          options.insert(0, height)
          options.insert(0, width)

          version "#{v[0]}_retina" do
            process processor[0] => options
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

  end

end