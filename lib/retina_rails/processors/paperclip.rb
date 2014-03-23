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
