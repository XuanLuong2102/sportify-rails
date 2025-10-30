# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users, id: :integer, primary_key: :user_id do |t|
      ## Custom fields
      t.integer :role_id
      t.string  :first_name, limit: 30
      t.string  :last_name,  limit: 30
      t.string  :username,  limit: 30
      t.integer :gender, default: 0, null: false
      t.string  :phone, limit: 20
      t.boolean :is_locked, default: false

      ## Database authenticatable
      t.string :email,              null: false, default: "", limit: 50
      t.string :encrypted_password, null: false, default: "", limit: 255

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable (optional)
      # t.integer  :sign_in_count, default: 0, null: false
      # t.datetime :current_sign_in_at
      # t.datetime :last_sign_in_at
      # t.string   :current_sign_in_ip
      # t.string   :last_sign_in_ip

      ## Confirmable (optional)
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email

      ## Lockable (optional)
      # t.integer  :failed_attempts, default: 0, null: false
      # t.string   :unlock_token
      # t.datetime :locked_at

      ## Timestamps
      t.timestamps null: false
    end

    # Indexes
    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :role_id
    add_foreign_key :users, :roles, column: :role_id, primary_key: :role_id
  end
end
