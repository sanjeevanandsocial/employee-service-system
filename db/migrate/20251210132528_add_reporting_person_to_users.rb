class AddReportingPersonToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :reporting_person_id, :integer
    add_index :users, :reporting_person_id
  end
end
