# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'retina_rails/version'

Gem::Specification.new do |gem|
  gem.name          = 'retina_rails'
  gem.version       = RetinaRails::VERSION
  gem.authors       = ['Johan van Zonneveld', 'Arjen Oosterkamp']
  gem.email         = ['johan@vzonneveld.nl', 'mail@arjen.me']
  gem.homepage      = 'https://github.com/jhnvz/retina_rails.git'
  gem.summary       = %q{Makes your live easier optimizing for retina displays}
  gem.description   = %q{Retina Rails automatically generates retina versions of your uploaded images (CarrierWave or Paperclip). It detects if a visitor has a retina display and if so it displays the @2x version}

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency 'bundler', '>= 1.0.0'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '>= 2.3'
  gem.add_development_dependency 'rspec-rails', '~> 2.0'
  gem.add_development_dependency 'carrierwave'
  gem.add_development_dependency 'paperclip'
  gem.add_development_dependency 'rmagick'
  gem.add_development_dependency 'sqlite3'
  gem.add_development_dependency 'coveralls'


  if RUBY_VERSION < "1.9.3"
    gem.add_dependency 'rails', '>= 3.2.0', '< 4.0.0'
  else
    gem.add_dependency 'rails', '>= 3.0'
  end
end
