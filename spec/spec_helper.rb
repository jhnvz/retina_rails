## Test coverage

require 'coveralls'
Coveralls.wear!

## Rails

require 'active_support'
require 'active_record'

## Carrierwave

require 'carrierwave'

## Paperclip

require 'paperclip'
require "paperclip/railtie"
Paperclip::Railtie.insert

## Setup fixture database for activerecord

ActiveRecord::Base.establish_connection(
  :adapter => "sqlite3",
  :database => File.dirname(__FILE__) + "/fixtures/db/retina_rails.sqlite3"
)

## Load rspec rails after initializing rails app

load 'spec/support/rails.rb'
load 'spec/support/schema.rb'
require 'rspec/rails'

## Load retina_rails

require 'retina_rails'

RetinaRails::Strategies.include_strategies

## Load support files

load 'spec/support/carrierwave.rb'
load 'spec/support/paperclip.rb'
load 'spec/support/file_string_io.rb'

RSpec.configure do |config|
  config.fixture_path = "#{File.dirname(__FILE__)}/fixtures"
end