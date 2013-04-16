module ActionView
  module Helpers
    module AssetTagHelper

      def image_tag_with_retina(source, options={})
        retina = options.delete(:retina)

        if retina
          retina_source = source.split('.')
          filename      = retina_source.slice!(-2)
          retina_source = retina_source.insert(-2, "#{filename}@2x").join('.')

          options.merge!(:data => { :at2x => path_to_image(retina_source) })
        end

        image_tag_without_retina(source, options)
      end
      alias_method_chain :image_tag, :retina

    end
  end
end