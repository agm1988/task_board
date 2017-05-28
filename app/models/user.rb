class User < ActiveRecord::Base
  validates :first_name, :last_name, :email, :nickname, presence: true
  validates :email, :nickname, uniqueness: true
end
