class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.references :report, index: true, foreign_key: true
      t.integer :status, null: false, default: 0, index: true

      t.timestamps null: false
    end
  end
end
