module Boundary
  class DuplicateAttributeValue < Boundary::TerminableError
    def initialize(argument)
      super(<<~MSG.strip)
        There is already an attribute value '#{argument}' for this assessment
      MSG
    end
  end
end
