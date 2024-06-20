class AddIndexesAndForeignKeys < ActiveRecord::Migration[7.1]
    def change
      # Add indexes
      add_index :users, :email, unique: true
      add_index :users, :reset_password_token, unique: true
      add_index :users, :uid, unique: true

      # Add foreign keys
      add_foreign_key :users, :grade_classes, column: :grade_class_id
      add_foreign_key :diaries, :users, column: :user_id
      add_foreign_key :stamps, :users, column: :user_id
      add_foreign_key :stamps, :diaries, column: :diary_id
    end
  end
