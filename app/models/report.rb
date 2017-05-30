class Report < ActiveRecord::Base
  belongs_to :user
  # maybe do not destroy dependent records?
  # TODO: mask as deleted dependent records
  has_many :tasks, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true

  validates :title, :tasks, presence: true
end
