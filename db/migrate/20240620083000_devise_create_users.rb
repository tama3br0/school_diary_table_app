# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[7.1]
    def change
      create_table :users do |t|
        ## Database authenticatable
        t.string :email, null: false, default: ""
        t.string :encrypted_password, null: false, default: ""

        ## Omniauthable
        t.string :uid, null: false
        t.string :provider

        ## Recoverable
        t.string :reset_password_token
        t.datetime :reset_password_sent_at

        ## Rememberable
        t.datetime :remember_created_at

        ## Custom fields
        t.string :name
        t.integer :role, null: false, default: 0
        t.bigint :grade_class_id
        t.integer :student_num

        t.timestamps null: false
      end
    end
  end
