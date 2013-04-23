module RetinaRails
  class Exception < StandardError
    attr_accessor :message

    def initialize(message)
      self.message = message
    end
  end

  class MisconfiguredError < Exception
    def initialize
      super <<eos
You must specify the file format of all Paperclip attached images like so:
:styles => {
  :original => ["800x800", :jpg],
  :big => ["125x125#", :jpg]
}
eos
    end
  end
end
