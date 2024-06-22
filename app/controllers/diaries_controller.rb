# app/controllers/diaries_controller.rb
class DiariesController < ApplicationController
    include DiariesHelper

    before_action :authenticate_user!

    def new
      @diary = Diary.new
      @questions = get_questions_with_emotions
    end

    def create
      date = diary_params[:date]
      current_user.diaries.where(date: date).destroy_all

      @questions = get_questions_with_emotions
      answers = params[:answers].values
      successful_save = true

      answers.each do |answer|
        question_num = answer[:question_num].to_i
        emotion_num = answer[:emotion_num].to_i

        diary_entry = current_user.diaries.build(date: date, question_num: question_num, emotion_num: emotion_num)

        if diary_entry.save
          next
        else
          successful_save = false
          break
        end
      end

      if successful_save
        redirect_to login_success_path, notice: 'にっきをとうろくしました。'
      else
        flash.now[:alert] = 'にっきのとうろくにしっぱいしました。もういちどためしてください。'
        @diary = Diary.new(diary_params)
        render :new
      end
    end

    private

    def diary_params
      params.require(:diary).permit(:date)
    end
end
