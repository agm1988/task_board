class User < ActiveRecord::Base
  include Stringify

  has_many :reports
  has_many :tasks, through: :reports

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, :last_name, :email, :nickname, :work_start_time, presence: true
  validates :email, :nickname, uniqueness: true

  # TODO: think on sql query
  # scope :without_todays_report, (lambda do
  #   joins(:reports)
  #     .where("reports.id = (SELECT MAX(reports.id) FROM reports \
  #         WHERE reports.user_id = users.id AND reports.status = 1)")
  #     .where('CAST(reports.reported_at AS time) < CAST(users.work_start_time AS time)')
  #     .group('users.id')
  #     end)

  def name
    "#{first_name[0]}. #{last_name}"
  end

  def skip_notifications!
    @skip = true
  end

  def email_changed?
    return false if @skip
    super
  end

  def encrypted_password_changed?
    return false if @skip
    super
  end
end
