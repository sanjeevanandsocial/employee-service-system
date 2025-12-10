class CreateTaskActivities < ActiveRecord::Migration[7.0]
  def change
    create_table :task_activities do |t|
      t.references :task, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :comment, null: false

      t.timestamps
    end
  end
end
