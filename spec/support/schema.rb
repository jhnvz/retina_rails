ActiveRecord::Schema.define do
  self.verbose = false

  create_table :paperclip_uploads, :force => true do |t|
    t.string :avatar_file_name
    t.string :avatar_without_quality_file_name
    t.string :avatar_string_styles_file_name
    t.timestamps
  end

end