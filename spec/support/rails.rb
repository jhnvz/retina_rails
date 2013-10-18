ENV['RAILS_ENV'] = 'test'

require "sprockets/railtie"

module RetinaRailsTest
  class Application < Rails::Application
    config.active_support.deprecation = :log

    if Rails::VERSION::STRING >= "4.0.0"
      config.secret_token    = 'existing secret token'
      config.secret_key_base = 'new secret key base'
    end

  end
end
RetinaRailsTest::Application.initialize!