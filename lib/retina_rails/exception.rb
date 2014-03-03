module RetinaRails

  class Exception < StandardError

    attr_accessor :message

    def initialize(message = nil)
      self.message = message
    end

  end # Exception < StandardError

  class DeprecationError < Exception; end

end # RetinaRails