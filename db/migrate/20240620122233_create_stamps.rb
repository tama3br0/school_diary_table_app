class CreateStamps < ActiveRecord::Migration[7.1]
    def change
      create_table :stamps do |t|
        t.bigint :user_id, null: false
        t.bigint :diary_id, null: false
        t.string :stamp_image, null: false

        t.timestamps
      end
    end
  end
