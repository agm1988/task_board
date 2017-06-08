# frozen_string_literal: true

class Report < ActiveRecord::Base
  include AASM

  REPORT_STATUSES = %i[draft reported].freeze

  belongs_to :user
  # maybe do not destroy dependent records?
  # TODO: mask as deleted dependent records
  has_many :tasks, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :task_comments, through: :tasks, source: :comments

  enum status: REPORT_STATUSES

  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true

  validates :title, :tasks, :user, presence: true

  scope :by_search, (lambda do |term|
    eager_load(:user)
      .where("reports.title ilike :term OR \
              users.first_name ilike :term OR \
              users.last_name ilike :term OR \
              users.nickname ilike :term", term: "%#{term}%")
  end)

  aasm column: :status, enum: true do
    state :draft, initial: true
    state :reported

    event :report do
      transitions from: :draft, to: :reported, success: proc { update(reported_at: Time.zone.now.utc) }
    end
  end
end
