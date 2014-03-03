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
      # retina_image_tag(@user, :avatar, :small)
      #
      def retina_image_tag(model, mounted_to, version, options={})
        dimensions = model.retina_dimensions[mounted_to.to_sym][version.to_sym]
        options    = dimensions.merge(options)

        image_tag(model.send(mounted_to).url(version), options)
      end

    end # AssetTagHelper
  end # Helpers
end # ActionView
