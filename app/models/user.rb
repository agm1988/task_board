class User < ActiveRecord::Base
  include Stringify

  has_many :reports
  has_many :tasks, through: :reports

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :email, :nickname, presence: true
  validates :email, :nickname, uniqueness: true

  def name
    "#{first_name[0]}. #{last_name}"
  end
end
