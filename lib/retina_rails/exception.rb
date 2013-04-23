module RetinaRails
  class Exception < StandardError
    attr_accessor :message

    def initialize(message)
      self.message = message
    end
  end

  class MisconfiguredError < Exception; end
end
