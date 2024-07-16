# db/seeds.rb

require 'faker'

# GradeClassの作成
grade_class = GradeClass.create!(
  grade: 1,
  class_num: 3,
  school_code: 1
)

# ユーザーの作成
users = []
30.times do |i|
  begin
    user = User.create!(
      email: "student#{i+1}@example.com",
      encrypted_password: Devise::Encryptor.digest(User, 'password'),
      uid: SecureRandom.uuid,
      role: 0, # student
      grade_class: grade_class,
      student_num: i + 1,
      additional_info_provided: false
    )
    users << user
  rescue ActiveRecord::RecordInvalid => e
    puts "ダミーユーザー生成に失敗しました: #{e.record.errors.full_messages.join(', ')}"
  end
end

# 日記の作成
emotions = {
  very_smile: 4,
  smile: 3,
  normal: 2,
  shock: 1
}

emotions_images = {
  very_smile: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/very_smile.png",
  smile: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/smile.png",
  normal: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/normal.png",
  shock: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/shock.png"
}

start_date = Date.new(2024, 4, 1)
end_date = Date.new(2024, 7, 27)

users.each do |user|
  (start_date..end_date).each do |date|
    next if date.saturday? || date.sunday? # 土日を除く

    question_num = rand(1..4)
    emotion_type = [:very_smile, :smile, :normal, :shock].sample(1, weights: [0.4, 0.4, 0.1, 0.1]).first

    Diary.create!(
      user: user,
      date: date,
      question_num: question_num,
      emotion_num: emotions[emotion_type],
      answer_image: emotions_images[emotion_type]
    )
  end
end

puts "ダミーデータを生成できました！"
