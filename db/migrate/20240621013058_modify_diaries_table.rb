class ModifyDiariesTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :diaries, :answer_num, :integer, null: false
    add_column :diaries, :question_num, :integer, null: false
    add_column :diaries, :emotion_num, :integer, null: false
  end
end
