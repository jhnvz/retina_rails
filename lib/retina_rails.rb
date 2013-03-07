require "retina_rails/version"
require 'retina_rails/extensions'
require "retina_rails/paperclip"
require "retina_rails/carrierwave"
require "retina_rails/helpers"

module RetinaRails

  if defined?(Rails)
    class Engine < Rails::Engine; end
  end

end
