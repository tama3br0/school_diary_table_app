class AddAnswerImageToDiaries < ActiveRecord::Migration[7.1]
  def change
    add_column :diaries, :answer_image, :string
  end
end
