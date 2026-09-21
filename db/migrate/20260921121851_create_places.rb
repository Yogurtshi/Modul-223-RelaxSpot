class CreatePlaces < ActiveRecord::Migration[8.1]
  def change
    create_table :places do |t|
      t.string :name, null: false
      t.integer :category, null: false, default: 0
      t.decimal :latitude, null: false, precision: 10, scale: 6
      t.decimal :longitude, null: false, precision: 10, scale: 6
      t.integer :capacity, null: false
      t.string :opening_hours
      t.integer :status, null: false, default: 0
      t.boolean :approved, null: false, default: false
      t.integer :proposed_by_id, null: false
      t.integer :locked_by_id
      t.datetime :locked_at

      t.timestamps
    end

    add_check_constraint :places, "capacity > 0", name: "places_capacity_positive"
    add_foreign_key :places, :users, column: :proposed_by_id
    add_foreign_key :places, :users, column: :locked_by_id

    add_index :places, :category
    add_index :places, :status
    add_index :places, :approved
  end
end
