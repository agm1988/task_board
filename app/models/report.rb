class Report < ActiveRecord::Base
  include AASM

  belongs_to :user
  # maybe do not destroy dependent records?
  # TODO: mask as deleted dependent records
  has_many :tasks, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :task_comments, through: :tasks, source: :comments

  enum status: [:draft, :reported]

  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true

  validates :title, :tasks, :user, presence: true

  aasm column: :status, enum: true do
    state :draft, initial: true
    state :reported

    event :report do
      transitions from: :draft, to: :reported
    end
  end
end
