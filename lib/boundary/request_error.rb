module Boundary
  class RequestError < StandardError
    attr_accessor :code, :title

    def initialize(msg = nil)
      super

      @code = 400
      @title = "INVALID_REQUEST"
    end
  end
end
