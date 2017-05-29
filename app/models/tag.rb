class Tag < ActiveRecord::Base
  include Stringify

  has_many :taggings
  has_many :tasks, through: :taggings

  validates :name, presence: true
end
