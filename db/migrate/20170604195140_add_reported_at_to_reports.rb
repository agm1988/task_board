class AddReportedAtToReports < ActiveRecord::Migration
  def change
    add_column :reports, :reported_at, :datetime
  end
end
