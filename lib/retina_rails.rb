require 'retina_rails/version'
require 'retina_rails/strategies'
require 'retina_rails/helpers'

module RetinaRails

  if defined?(Rails)
    class Engine < Rails::Engine; end
  end

end
