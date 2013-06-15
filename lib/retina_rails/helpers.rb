module ActionView
  module Helpers
    module AssetTagHelper

      def image_tag_with_retina(source, options={})
        retina = options.delete(:retina)

        if retina
          retina_source = source.to_s
          retina_source = retina_source.split('.')
          filename      = retina_source.slice!(-2)
          retina_source = retina_source.insert(-2, "#{filename}@2x").join('.')

          options[:data] ||= {}
          options[:data].merge!(:at2x => path_to_image(retina_source))
        end

        image_tag_without_retina(source, options)
      end
      alias_method_chain :image_tag, :retina

      def get_retina_url(source)
        retina_source = source.to_s
        retina_source = retina_source.split('.')
        filename      = retina_source.slice!(-2)
        retina_source = retina_source.insert(-2, "#{filename}@2x").join('.')

        path_to_image(retina_source)
      end
    end
  end
end
