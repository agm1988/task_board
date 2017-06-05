# frozen_string_literal: true

module Stringify
  def to_s
    name if respond_to? :name
  end
end
