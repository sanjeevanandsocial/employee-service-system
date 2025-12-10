class AddReportingPersonToLeaveRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :leave_requests, :reporting_person_id, :integer
    add_index :leave_requests, :reporting_person_id
  end
end