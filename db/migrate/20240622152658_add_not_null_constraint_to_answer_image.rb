class AddNotNullConstraintToAnswerImage < ActiveRecord::Migration[7.1]
    def change
      change_column_null :diaries, :answer_image, false
    end
end
