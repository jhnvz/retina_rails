## Retina Rails

[![Gem Version](https://badge.fury.io/rb/retina_rails.png)](http://badge.fury.io/rb/retina_rails) [![Build Status](https://secure.travis-ci.org/jhnvz/retina_rails.png?branch=master)](http://travis-ci.org/jhnvz/retina_rails) [![Coverage Status](https://coveralls.io/repos/jhnvz/retina_rails/badge.png?branch=master)](https://coveralls.io/r/jhnvz/retina_rails) [![Code Climate](https://codeclimate.com/github/jhnvz/retina_rails.png)](https://codeclimate.com/github/jhnvz/retina_rails) [![Dependency Status](https://gemnasium.com/jhnvz/retina_rails.png)](https://gemnasium.com/jhnvz/retina_rails)

Makes your life easier optimizing an application for retina displays.

How it works
------------

Retina Rails automatically generates retina versions of your uploaded images (CarrierWave or Paperclip). It detects if a visitor has a retina display and if so it displays the @2x version.

Note: It also works for images that live in assets/images.

Installation
------------

1. Add `gem 'retina_rails'` to your Gemfile.
1. Run `bundle install`.
1. Add `//= require retina` to your Javascript manifest file (usually found at `app/assets/javascripts/application.js`).

CarrierWave
------------

Simply add `retina!` to your uploader.

```ruby
class ExampleUploader < CarrierWave::Uploader::Base

  retina!

  version :small do
    process :resize_to_fill => [30, 30]
    process :retina_quality => 25
  end

  version :large, :retina => false do
    process :resize_to_fill => [1000, 1000]
  end

end
```
By default it sets the retina image quality to 40 which can be overriden with `process :retina_quality => 25`. To disable the creation of a retina version simply call `version :small, :retina => false`.

### Custom processors

You can also use your custom processors like so:

```ruby
class ExampleUploader < CarrierWave::Uploader::Base

  retina!

  version :small, :retina => false do
    process :resize_to_fill_with_gravity => [100, 100, 'North', :jpg, 75]
  end

  version :small_retina, :retina => false do
    process :resize_to_fill_with_gravity => [200, 200, 'North', :jpg, 40]
  end

end
```

This will generate `small.jpg` and `small@2x.jpg`.


Paperclip
------------

Simply set `:retina` to true.

```ruby
class ExampleUploader < ActiveRecord::Base

  has_attached_file :image,
    :styles => {
       :original => ["800x800", :jpg],
       :big => ["125x125#", :jpg]
     },
     :retina => true # Or
     :retina => { :quality => 25 } # Optional

end
```
By default it sets the retina image quality to 40 which can be overriden by adding a `quality` option. To use without ActiveRecord simply include `Paperclip::Glue` and it will work.

For retina images use
------------

```ruby
image_tag('image.png', :retina => true)
```

Voila! Now you're using Retina Rails.

Supported Ruby Versions
------------

This library aims to support and is tested against[travis] the following Ruby
implementations:

* Ruby 1.9.2
* Ruby 1.9.3
* Ruby 2.0.0

Credits
------------

Retina Rails uses retinajs (https://github.com/imulus/retinajs)

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Copyright
------------

Copyright (c) 2012 Johan van Zonneveld. See LICENSE for details.
