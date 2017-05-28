class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, index: true, unique: true
      t.boolean :is_admin, null: false, default: false
      t.string :nickname, index: true, unique: true

      t.timestamps null: false
    end
  end
end
