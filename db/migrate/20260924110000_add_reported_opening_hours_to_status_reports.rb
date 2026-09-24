class AddReportedOpeningHoursToStatusReports < ActiveRecord::Migration[8.1]
  def change
    add_column :status_reports, :reported_opening_hours, :string
  end
end
