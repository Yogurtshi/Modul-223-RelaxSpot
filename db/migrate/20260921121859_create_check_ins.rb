class CreateCheckIns < ActiveRecord::Migration[8.1]
  def change
    create_table :check_ins do |t|
      t.references :place, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :started_at, null: false
      t.datetime :ends_at, null: false

      t.timestamps
    end

    add_check_constraint :check_ins,
      "ends_at > started_at",
      name: "check_ins_ends_after_start"

    add_index :check_ins, [ :place_id, :ends_at ]
    add_index :check_ins, [ :user_id, :place_id ]
  end
end
