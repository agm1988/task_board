# frozen_string_literal: true

module Maybe
  class None
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def some?
      false
    end
  end
end
