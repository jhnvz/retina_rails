module ActionView
  module Helpers
    module AssetTagHelper

      ##
      # Displays a version of an upload and sets stored width and height attributes
      #
      # === Parameters
      #
      # [model (Model)] model instance
      # [mounted_to (Sym)] attribute to which uploader is mounted
      # [version (Sym)] version of the upload
      # [options (Hash)] optional options hash
      #
      # === Examples
      #
      # retina_image_tag(@user, :avatar, :small, :default => { :width => 300, :height => 200 })
      # retina_image_tag(@user, :avatar, :small, :default => [300, 200])
      #
      def retina_image_tag(model, mounted_to, version, options={})
        default = options.delete(:default)

        # Check if we can find the dimensions of the uploaded image.
        # If no image or dimensions available use default.
        if model.retina_dimensions.kind_of?(Hash) && model.retina_dimensions[mounted_to.to_sym]
          dimensions = model.retina_dimensions[mounted_to.to_sym][version.to_sym]
        else
          if default.kind_of?(Array)
            default = { :width => default[0], :height => default[1] }
          end
          dimensions = default || {}
        end

        options = dimensions.merge(options)

        image_tag(model.send(mounted_to).url(version), options)
      end
    end # AssetTagHelper
  end # Helpers
end # ActionView
