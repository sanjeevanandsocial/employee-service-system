class AddReportingPersonToOdRequests < ActiveRecord::Migration[7.2]
  def change
    add_column :od_requests, :reporting_person_id, :integer
    add_index :od_requests, :reporting_person_id
  end
end