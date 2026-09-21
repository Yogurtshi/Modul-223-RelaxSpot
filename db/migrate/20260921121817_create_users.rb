class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :role, null: false, default: 0
      t.boolean :locked, null: false, default: false
      t.string :unconfirmed_email
      t.string :confirmation_token

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :confirmation_token, unique: true
  end
end
