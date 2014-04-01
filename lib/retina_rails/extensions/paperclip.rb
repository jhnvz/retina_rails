module RetinaRails
  module Extensions
    module Paperclip
      module Style

        def self.included base
          base.class_eval do
            alias_method :original_processor_options, :processor_options

            ##
            # Make sure to add the current style being processed to the args
            # so we can identify which style is being processed
            #
            def processor_options
              original_processor_options.merge!(:style => name)
            end
          end
        end

      end # Style
    end # Paperclip
  end # Extensions
end # RetinaRails
