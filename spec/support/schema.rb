ActiveRecord::Schema.define do
  self.verbose = false

  create_table :paperclip_uploads, :force => true do |t|
    t.string :avatar_file_name
    t.timestamps
  end

end