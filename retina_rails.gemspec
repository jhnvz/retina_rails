# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'retina_rails/version'

Gem::Specification.new do |gem|
  gem.name          = "retina_rails"
  gem.version       = RetinaRails::VERSION
  gem.authors       = ["Johan van Zonneveld"]
  gem.email         = ["johan@vzonneveld.nl"]
  gem.homepage      = 'https://github.com/jhnvz/retina_rails.git'
  gem.summary       = %q{Automatically generates retina versions of your uploaded images}

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler", ">= 1.0.0"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec", ">= 2.3"
  gem.add_development_dependency 'carrierwave'
  gem.add_development_dependency 'paperclip'
  gem.add_development_dependency "sqlite3"

  gem.add_dependency 'rails', '>= 3.0'
  gem.add_dependency 'rmagick'
end
