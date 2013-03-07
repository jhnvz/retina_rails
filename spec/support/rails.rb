ENV['RAILS_ENV'] = 'test'

require "sprockets/railtie"

module RetinaRailsTest
  class Application < Rails::Application
    config.active_support.deprecation = :log

    config.assets.manifest = Rails.public_path.gsub('public', 'spec/fixtures')

    ## Asset config

    config.assets.version      = '1.0'
    config.serve_static_assets = false
    config.assets.enabled      = true
    config.assets.compress     = true
    config.assets.compile      = false
    config.assets.digest       = true
  end
end
RetinaRailsTest::Application.initialize!