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
  gem.summary       = %q{Makes your life easier optimizing your application for retina displays}
  gem.description   = %q{Retina Rails makes your application use high-resolution images by default. It automatically optimizes uploaded images (CarrierWave or Paperclip) for retina displays by making them twice the size and reducing the quality.}
  gem.license       = 'MIT'

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

  if RUBY_VERSION > '1.9.2'
    gem.add_dependency 'rails', '>= 3.2.0'
  else
    gem.add_dependency 'rails', '>= 3.2.0', '< 4.0.0'
  end

  if File.exists?('UPGRADING')
    gem.post_install_message = File.read("UPGRADING")
  end
end
