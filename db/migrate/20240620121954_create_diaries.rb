class CreateDiaries < ActiveRecord::Migration[7.1]
    def change
      create_table :diaries do |t|
        t.bigint :user_id, null: false
        t.date :date, null: false
        t.integer :answer_num, null: false

        t.timestamps
      end
    end
  end
