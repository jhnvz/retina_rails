require 'retina_rails/version'
require 'retina_rails/extensions'
require 'retina_rails/strategies'
require 'retina_rails/helpers'

module RetinaRails

  if defined?(Rails)
    class Railtie < Rails::Railtie
      initializer "retina_rails.include_strategies" do
         RetinaRails::Strategies.include_strategies
      end
      initializer "retina_rails.include_extenions" do
         RetinaRails::Extensions.include_extensions
      end
    end
  end

end
