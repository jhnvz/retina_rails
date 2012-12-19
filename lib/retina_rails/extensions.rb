module RetinaRails::Extensions

  ## Insert :retina interpolation in url or path
  def self.optimize_path(path)
    path.scan(':retina').empty? ? path.gsub(':filename', ':basename.:extensions').split('.').insert(-2, ':retina.').join : path
  end

  def self.override_default_options

    ## Remove _retina from style so it doesn't end up in filename
    Paperclip.interpolates :style do |attachment, style|
      style.to_s.end_with?('_retina') ? style.to_s[0..-8] : style
    end

    ## Replace :retina with @2x if style ends with _retina
    Paperclip.interpolates :retina do |attachment, style|
      style.to_s.end_with?('_retina') ? '@2x' : ''
    end

    ## Make default url compatible with retina optimzer
    url = Paperclip::Attachment.default_options[:url]
    Paperclip::Attachment.default_options[:url] = optimize_path(url)

  end

end