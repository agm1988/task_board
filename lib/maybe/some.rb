# frozen_string_literal: true

module Maybe
  class Some
    attr_reader :value

    def initialize(value)
      @value = value
    end

    def some?
      true
    end
  end
end
