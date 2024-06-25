require 'faker'

# Create grade classes if they don't exist
grade_classes = {}
[1, 2].each do |school_code|
  [1, 2].each do |grade|
    [1, 2, 3].each do |class_num|
      grade_classes["#{school_code}_#{grade}_#{class_num}"] = GradeClass.find_or_create_by(
        grade: grade,
        class_num: class_num,
        school_code: school_code
      )
    end
  end
end

# Define emotion images
emotions = {
  4 => "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/very_smile.png",
  3 => "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/smile.png",
  2 => "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/normal.png",
  1 => "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/shock.png"
}

# Create users and diaries
grade_classes.each do |key, grade_class|
  (1..30).each do |student_num|
    begin
      user = User.find_or_create_by!(
        email: Faker::Internet.unique.email,
        uid: SecureRandom.uuid,
        provider: 'google_oauth2',
        name: '',  # role=0の場合はnameを空にする
        role: 0,
        grade_class: grade_class,
        student_num: student_num,
        additional_info_provided: true
      ) do |u|
        u.password = Devise.friendly_token[0, 20] # 一時的なランダムなパスワードを設定
      end

      # Create diaries if they don't exist
      (Date.new(2024, 4, 1)..Date.today).each do |date|
        (1..4).each do |question_num|
          emotion_num = rand(1..4)
          unless Diary.exists?(user: user, date: date, question_num: question_num)
            Diary.create!(
              user: user,
              date: date,
              question_num: question_num,
              emotion_num: emotion_num,
              answer_image: emotions[emotion_num] # emotion_numに基づいた画像URLを設定
            )
          end
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      puts "Failed to create user #{student_num} in grade_class #{key}: #{e.record.errors.full_messages.join(', ')}"
    end
  end
end

puts "Dummy data created successfully without deleting existing data."
