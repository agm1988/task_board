class Task < ActiveRecord::Base
  STATUSES = %i(todo done backlog).freeze

  belongs_to :report
  # belongs_to :user, through: :report
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :comments, as: :commentable, dependent: :destroy

  # enum status: STATUSES
  enum status: [:todo, :done, :backlog]

  accepts_nested_attributes_for :taggings, reject_if: :all_blank, allow_destroy: true

  validates :title, :description, :status, :tags, presence: true
end
