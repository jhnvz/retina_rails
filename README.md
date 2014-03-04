## Retina Rails

[![Gem Version](https://badge.fury.io/rb/retina_rails.png)](http://badge.fury.io/rb/retina_rails) [![Build Status](https://secure.travis-ci.org/jhnvz/retina_rails.png?branch=master)](http://travis-ci.org/jhnvz/retina_rails) [![Coverage Status](https://coveralls.io/repos/jhnvz/retina_rails/badge.png?branch=master)](https://coveralls.io/r/jhnvz/retina_rails) [![Code Climate](https://codeclimate.com/github/jhnvz/retina_rails.png)](https://codeclimate.com/github/jhnvz/retina_rails) [![Dependency Status](https://gemnasium.com/jhnvz/retina_rails.png)](https://gemnasium.com/jhnvz/retina_rails)

Makes your life easier optimizing an application for retina displays.

How it works
------------

Retina Rails makes your application use high-resolution images by default. It automatically optimizes uploaded images (CarrierWave or Paperclip) for retina displays by making them twice the size and reducing the quality.

*Good source on setting up image quality: http://www.netvlies.nl/blog/design-interactie/retina-revolution*

Resources
------------

- [Installation](#installation)
- [Migrations](#migrations)
- [Carrierwave](#carrierwave)
- [Paperclip](#paperclip)
- [Displaying a retina image](#displaying-a-retina-image)
- [Upgrading](#upgrading)

Installation
------------

1. Add `gem 'retina_rails', '~> 2.0.0'` to your Gemfile.
1. Run `bundle install`.

Migrations
------------

Add a text column named `retina_dimensions`. In this column we'll store the original dimensions of the uploaded images.

```ruby
class AddRetinaDimensionsColumnsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :retina_dimensions, :text
  end

  def self.down
    remove_column :users, :retina_dimensions, :text
  end
end
```

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


Paperclip
------------

Simply add `retina!` to your model.

```ruby
class ExampleUploader < ActiveRecord::Base

  retina!

  has_attached_file :image,
    :styles => {
       :original => ["800x800", :jpg],
       :big => ["125x125#", :jpg]
     },
     :retina => { :quality => 25 } # Optional

end
```
By default it sets the retina image quality to 40 which can be overriden by adding a `quality` option. To disable the creation of a retina version set the `retina` option to false `:retina => false`.

Displaying a retina image
------------

```ruby
retina_image_tag(@user, :avatar, :small)
```

Voila! Now you're using Retina Rails.

Upgrading
------------

How to upgrade from version 1 to 2

Supported Ruby Versions
------------

This library is tested against Travis and aims to support the following Ruby
implementations:

* Ruby 1.9.2
* Ruby 1.9.3
* Ruby 2.0.0
* Ruby 2.1.1

Contributing
------------

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Copyright
------------

Copyright (c) 2012-2014 Johan van Zonneveld. See LICENSE for details.
