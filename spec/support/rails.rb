ENV['RAILS_ENV'] = 'test'

require "sprockets/railtie"

module RetinaRailsTest
  class Application < Rails::Application
    config.active_support.deprecation = :log

    config.assets.manifest = Rails.root.join("spec/fixtures")

    ## Asset config

    config.assets.version      = '1.0'
    config.serve_static_assets = false
    config.assets.enabled      = true
    config.assets.compress     = true
    config.assets.compile      = false
    config.assets.digest       = true

    if Rails::VERSION::STRING >= "4.0.0"
      config.secret_token    = 'existing secret token'
      config.secret_key_base = 'new secret key base'
    end

  end
end
RetinaRailsTest::Application.initialize!