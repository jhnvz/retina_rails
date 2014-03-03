class PaperclipUpload < ActiveRecord::Base

  retina!

  has_attached_file :avatar

  validates_attachment :avatar, :presence => true, :content_type => { :content_type => ["image/jpg", "image/jpeg", "image/png"] }

end
