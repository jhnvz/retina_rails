## Retina Rails

[![Gem Version](https://badge.fury.io/rb/retina_rails.png)](http://badge.fury.io/rb/retina_rails) [![Build Status](https://secure.travis-ci.org/jhnvz/retina_rails.png?branch=master)](http://travis-ci.org/jhnvz/retina_rails) [![Coverage Status](https://coveralls.io/repos/jhnvz/retina_rails/badge.png?branch=master)](https://coveralls.io/r/jhnvz/retina_rails) [![Code Climate](https://codeclimate.com/github/jhnvz/retina_rails.png)](https://codeclimate.com/github/jhnvz/retina_rails) [![Dependency Status](https://gemnasium.com/jhnvz/retina_rails.png)](https://gemnasium.com/jhnvz/retina_rails)

Makes your live easier optimizing an application for retina displays.

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

Add `include RetinaRails::CarrierWave` to the bottom of your uploader

```ruby
class ExampleUploader < CarrierWave::Uploader::Base

  version :small do
    process :resize_to_fill => [30, 30]
  end

  include RetinaRails::CarrierWave

end
```

Paperclip
------------

Add `include RetinaRails::Paperclip` to the bottom of your class

```ruby
class ExampleUploader < ActiveRecord::Base

  has_attached_file :image,
    :styles => {
       :original => ["800x800", :jpg],
       :big => ["125x125#", :jpg]
     }

  include RetinaRails::Paperclip

end
```

Make sure that you include the file format for all styles like so  ```:original => ["800x800", :jpg]```. Omitting it will result in a ```MisconfiguredError``` being raised.

For retina images use
------------

```ruby
image_tag('image.png', :retina => true)
```

Voila! Now you're using Retina Rails.

Credits
------------

Retina Rails uses retinajs (https://github.com/imulus/retinajs)

Note on Patches/Pull Requests
------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
------------

Copyright (c) 2012 Johan van Zonneveld. See LICENSE for details.
