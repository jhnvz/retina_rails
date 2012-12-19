require 'active_support'
require 'active_record'

require 'carrierwave'


require 'paperclip'
require "paperclip/railtie"
Paperclip::Railtie.insert

require 'retina_rails'

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => File.dirname(__FILE__) + "/fixtures/db/retina_rails.sqlite3"
)

load File.dirname(__FILE__) + '/support/schema.rb'