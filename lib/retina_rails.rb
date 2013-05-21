require 'retina_rails/version'
require 'retina_rails/strategies'
require 'retina_rails/helpers'
require 'retina_rails/exception'

require 'retina_rails/deprecation/carrierwave'
require 'retina_rails/deprecation/paperclip'

module RetinaRails

  if defined?(Rails)
    class Engine < Rails::Engine; end
  end

end
