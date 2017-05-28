class Task < ActiveRecord::Base
  STATUSES = %i(todo done backlog).freeze

  belongs_to :report
  # belongs_to :user, through: :report

  # enum status: STATUSES
  enum status: [:todo, :done, :backlog]
end
