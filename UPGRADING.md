# Upgrading

In version 2.0.0 we got rid of double image uploads and and the javascript helper. Retina Rails now displays high-resolution images by default instead of swapping the low-res image with a high-res version. This will save up on requests and storage.

Since the whole strategy for displaying images has changed there are some things you need to do for version 2.0.0 to work.

## Javascript helper

Remove `//= require retina` from your Javascript manifest file (usually found at app/assets/javascripts/application.js) since we don't need it anymore.

## Migrations

You'll need to add a `retina_dimensions` column to the table of every model using retina optimised image uploads.

**For example:**
```ruby
class AddRetinaDimensionsColumnToUsers < ActiveRecord::Migration
  def self.change
    add_column :users, :retina_dimensions, :text
  end
end
```

## Displaying images

Instead of rendering images with the `image_tag` method we now render with `retina_image_tag`.

**Old way:**
```ruby
image_tag(@user.image.url(:small), :retina => true)
```

**New way:**
```ruby
retina_image_tag(@user, :image, :small, :default => { :width => 50, :height => 40 })
```

## Reprocessing uploads

Since we only store the retina optimised version we need to save the original dimensions of the uploaded image. Every uploaded image needs to be reprocessed.

### Carrierwave

Open up a console and run:
```ruby
Model.find_each do |model|
  model.image.recreate_versions!
end
```
Or create a rake task that will do the trick for you.

### Paperclip

Run: `rake paperclip:refresh`

---

Make sure to run a test on your local machine or your staging environment before deploying to a production environment.
