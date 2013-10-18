require 'retina_rails/version'
require 'retina_rails/strategies'
require 'retina_rails/helpers'
require 'retina_rails/exception'

module RetinaRails

  if defined?(Rails)
    class Engine < Rails::Engine; end

    class Railtie < Rails::Railtie
      initializer "retina_rails.include_strategies" do
         RetinaRails::Strategies.include_strategies
      end
    end
  end

end
