class AddNeedNotificationToComments < ActiveRecord::Migration
  def change
    add_column :comments, :need_notification, :boolean, null: false, default: false
  end
end
