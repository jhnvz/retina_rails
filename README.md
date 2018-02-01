## Retina Rails

[![Gem Version](http://img.shields.io/gem/v/retina_rails.svg?style=flat)][gem]
[![Build Status](http://img.shields.io/travis/jhnvz/retina_rails.svg?style=flat)][travis]
[![Coverage Status](http://img.shields.io/coveralls/jhnvz/retina_rails.svg?style=flat)][coveralls]
[![Code Climate](http://img.shields.io/codeclimate/github/jhnvz/retina_rails.svg?style=flat)][codeclimate]
[![Dependency Status](http://img.shields.io/gemnasium/jhnvz/retina_rails.svg?style=flat)][gemnasium]

[gem]: https://rubygems.org/gems/retina_rails
[travis]: http://travis-ci.org/jhnvz/retina_rails
[coveralls]: https://coveralls.io/r/jhnvz/retina_rails
[codeclimate]: https://codeclimate.com/github/jhnvz/retina_rails
[gemnasium]: https://gemnasium.com/jhnvz/retina_rails

Makes your life easier optimizing an application for retina displays.

### Still using version 1.0.x?

---

Check [upgrading](https://github.com/jhnvz/retina_rails/blob/master/UPGRADING.md) to upgrade or the version 1.0.x [readme](https://github.com/jhnvz/retina_rails/tree/1.0.4).

---

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
- [Upgrading](https://github.com/jhnvz/retina_rails/blob/master/UPGRADING.md)

Installation
------------

1. Add `gem 'retina_rails', '~> 2.0.0'` to your Gemfile.
1. Run `bundle install`.

Migrations
------------

Add a text column named `retina_dimensions`. This column is used to store original dimensions of the images.

```ruby
class AddRetinaDimensionsToUsers < ActiveRecord::Migration
  def self.change
    add_column :users, :retina_dimensions, :text
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
    process :retina_quality => 80
  end

  version :large, :retina => false do
    process :resize_to_fill => [1000, 1000]
  end

end
```

By default it sets the retina image quality to 60 which can be overriden with `process :retina_quality => 80`. To disable the creation of a retina version simply call `version :small, :retina => false`.

### Custom resize processors

You can also use your custom resize processors like so:

```ruby
class ExampleUploader < CarrierWave::Uploader::Base

  retina!

  version :small, :retina => false do
    process :resize_to_fill_with_gravity => [200, 200, 'North', :jpg, 75]
    process :store_retina_dimensions
  end

end
```

Make sure you double the image size yourself in your processor. In this example the image will be displayed with a size of 100x100.


Paperclip
------------

Simply add `retina!` to your model.

```ruby
class ExampleUploader < ActiveRecord::Base

  retina!

  has_attached_file :image,
    :styles => {
       :original => ["800x800", :jpg],
       :small => ["125x125#", :jpg]
     },
     :retina => { :quality => 80 }

end
```

By default it sets the retina image quality to 60 which can be overriden by adding a `quality` option. To disable the creation of a retina version set the `retina` option to false `:retina => false`.

Displaying a retina image
------------

```ruby
retina_image_tag(@user, :image, :small, :default => [50, 40])
# or
retina_image_tag(@user, :image, :small, :default => { :width => 50, :height => 40 })
```

If no image is uploaded (yet) it will display the default image defined with CarrierWave or Paperclip and set the width and height attributes specified in the default option.

**Voila! Now you're using Retina Rails.**

Supported Ruby Versions
------------

This library is tested against Travis and aims to support the following Ruby and Rails
implementations:

* Ruby 2.1
* Ruby 2.2
* Ruby 2.3
* Ruby 2.4
* Rails 4.2
* Rails 5.0
* Rails 5.1

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
