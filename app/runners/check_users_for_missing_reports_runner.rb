class CheckUsersForMissingReportsRunner
  include Sidekiq::Worker

  # TODO: refactor to sql query
  def perform
    time = Time.zone.now.utc

    start_time = (time - 1.hour - 10.minutes).to_s(:time)
    end_time = (time - 1.hour + 10.minutes).to_s(:time)

    User.includes(:reports).where('work_start_time::time > ? AND work_start_time < ?',  start_time, end_time)
      .find_each do |user|
      last_reported_report = user.reports.reported.last

      if last_reported_report
        user_start_time = time.change(hour: user.work_start_time.hour, min: user.work_start_time.min)
        return if (user_start_time .. time).include?(last_reported_report.reported_at)

        ::Notifications::UserReportReminderJob.perform_async(user.id)
      else
        ::Notifications::UserReportReminderJob.perform_async(user.id)
      end
    end
  end
end
