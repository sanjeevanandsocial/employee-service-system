class CreateLeaveRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :leave_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.date :from_date, null: false
      t.date :to_date, null: false
      t.text :reason, null: false
      t.integer :status, default: 0
      t.timestamps
    end
  end
end