class CreateCheckInHolds < ActiveRecord::Migration[8.1]
  def change
    create_table :check_in_holds do |t|
      t.datetime :expires_at, null: false
      t.references :place, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :created_at, null: false
      t.datetime :updated_at, null: false
    end

    add_index :check_in_holds, [ :place_id, :user_id ], unique: true
    add_index :check_in_holds, [ :place_id, :expires_at ]
  end
end
