class Report < ActiveRecord::Base
  belongs_to :user
  has_many :tasks

  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true
end
