class CreateStatusReports < ActiveRecord::Migration[8.1]
  def change
    create_table :status_reports do |t|
      t.references :place, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :reported_status, null: false
      t.boolean :reviewed, null: false, default: false

      t.timestamps
    end

    add_index :status_reports, :reviewed
    add_index :status_reports, [ :place_id, :reviewed ]
  end
end
