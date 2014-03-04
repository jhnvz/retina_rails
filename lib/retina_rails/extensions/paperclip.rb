module Paperclip
  class Style

    # Make sure to add the current style being processed to the args
    # so we can identify which style is being processed
    def processor_options
      args = { :style => name }
      @other_args.each do |k,v|
        args[k] = v.respond_to?(:call) ? v.call(attachment) : v
      end
      [:processors, :geometry, :format, :whiny, :convert_options, :source_file_options].each do |k|
        (arg = send(k)) && args[k] = arg
      end
      args
    end

  end # Style
end # Paperclip