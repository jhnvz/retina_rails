module Paperclip
  class Style

    # Supplies the hash of options that processors expect to receive as their second argument
    # Arguments other than the standard geometry, format etc are just passed through from
    # initialization and any procs are called here, just before post-processing.
    def processor_options
      args = {}
      @other_args.each do |k,v|
        args[k] = v.respond_to?(:call) ? v.call(attachment) : v
      end
      [:processors, :geometry, :format, :whiny, :convert_options, :source_file_options].each do |k|
        (arg = send(k)) && args[k] = arg
      end
      args.merge!(:style => name)
    end

  end # Style
end # Paperclip