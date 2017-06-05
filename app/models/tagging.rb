# frozen_string_literal: true

class Tagging < ActiveRecord::Base
  belongs_to :task
  belongs_to :tag
end
