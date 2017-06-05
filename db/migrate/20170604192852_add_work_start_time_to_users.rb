class AddWorkStartTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :work_start_time, :time
  end
end
