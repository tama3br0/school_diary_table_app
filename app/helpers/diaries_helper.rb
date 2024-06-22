module DiariesHelper
    def display_user_info(user)
      if user.teacher?
        "#{user.name}せんせい"
      else
        "#{user.grade_class.grade}ねん#{user.grade_class.class_num}くみ #{user.student_num}ばん"
      end
    end

    def generate_diary_text_with_emotions(diary)
      text = ""
      questions_with_emotions = get_questions_with_emotions

      question = questions_with_emotions.find { |q| q[:question_num] == diary.question_num }
      emotion = question[:emotions].find { |e| e[:emotion_num] == diary.emotion_num }

      case question[:question_num]
      when 1
        text += generate_school_fun_text_with_emotion(emotion[:text])
      when 2
        text += generate_study_understanding_text_with_emotion(emotion[:text])
      when 3
        text += generate_recess_fun_text_with_emotion(emotion[:text])
      when 4
        text += generate_lunch_eating_text_with_emotion(emotion[:text])
      end

      text
    end

    def display_emotion_image(diary)
      image_tag(diary.answer_image, alt: "emotion")
    end

    def get_questions_with_emotions
      [
        {
          question_num: 1,
          text: "がっこうは たのしかったですか？",
          emotions: [
            { emotion_num: 4, text: "とても たのしかった", level: 4, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/very_smile.png" },
            { emotion_num: 3, text: "たのしかった", level: 3, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/smile.png" },
            { emotion_num: 2, text: "すこしだけ たのしかった", level: 2, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/normal.png" },
            { emotion_num: 1, text: "たのしくなかった", level: 1, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/shock.png" }
          ]
        },
        {
          question_num: 2,
          text: "がっこうの べんきょうは よくわかりましたか？",
          emotions: [
            { emotion_num: 4, text: "とても よくわかった", level: 4, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/very_smile.png" },
            { emotion_num: 3, text: "よくわかった", level: 3, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/smile.png" },
            { emotion_num: 2, text: "すこしだけ わかった", level: 2, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/normal.png" },
            { emotion_num: 1, text: "わからなかった", level: 1, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/shock.png" }
          ]
        },
        {
          question_num: 3,
          text: "やすみじかんは たのしく あそべましたか？",
          emotions: [
            { emotion_num: 4, text: "とても たのしかった", level: 4, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/very_smile.png" },
            { emotion_num: 3, text: "たのしかった", level: 3, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/smile.png" },
            { emotion_num: 2, text: "すこしだけ たのしかった", level: 2, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/normal.png" },
            { emotion_num: 1, text: "たのしくなかった", level: 1, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/shock.png" }
          ]
        },
        {
          question_num: 4,
          text: "きゅうしょくは たべられましたか？",
          emotions: [
            { emotion_num: 4, text: "ぜんぶたべて、おかわりもした", level: 4, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/very_smile.png" },
            { emotion_num: 3, text: "のこさずに、ぜんぶたべた", level: 3, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/smile.png" },
            { emotion_num: 2, text: "へらしたけれど、ぜんぶたべた", level: 2, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/normal.png" },
            { emotion_num: 1, text: "すこしだけ のこしてしまった", level: 1, image_url: "https://school-diary-app-bucket.s3.ap-northeast-1.amazonaws.com/shock.png" }
          ]
        }
      ]
    end

    def japanese_wday(date)
      wdays = %w[日 月 火 水 木 金 土]
      wdays[date.wday]
    end

    private

    def generate_school_fun_text_with_emotion(emotion_text)
      case emotion_text
      when "とても たのしかった"
        "きょうの がっこうは、 とても たのしかったです。<br>"
      when "たのしかった"
        "きょうの がっこうは たのしかったです。<br>"
      when "すこしだけ たのしかった"
        "きょうの がっこうは すこしだけ たのしかったです。<br>"
      when "たのしくなかった"
        "きょうの がっこうは あまり たのしくなかったです。<br>"
      else
        ""
      end
    end

    def generate_study_understanding_text_with_emotion(emotion_text)
      case emotion_text
      when "とても よくわかった"
        "きょうの べんきょうは、 とても よく わかりました。<br>"
      when "よくわかった"
        "きょうの べんきょうは よく わかりました。<br>"
      when "すこしだけ わかった"
        "きょうの べんきょうは すこしだけ わかりました。<br>"
      when "わからなかった"
        "きょうの べんきょうは あまり わかりませんでした。<br>"
      else
        ""
      end
    end

    def generate_recess_fun_text_with_emotion(emotion_text)
      case emotion_text
      when "とても たのしかった"
        "やすみじかんは、 とても たのしく あそべました。<br>"
      when "たのしかった"
        "やすみじかんは たのしく あそべました。<br>"
      when "すこしだけ たのしかった"
        "やすみじかんは すこしだけ たのしく あそべました。<br>"
      when "たのしくなかった"
        "やすみじかんは あまり たのしく あそべませんでした。<br>"
      else
        ""
      end
    end

    def generate_lunch_eating_text_with_emotion(emotion_text)
      case emotion_text
      when "ぜんぶたべて、おかわりもした"
        "きゅうしょくは ぜんぶたべて、おかわりも しました。<br>"
      when "のこさずに、ぜんぶたべた"
        "きゅうしょくは のこさずに、ぜんぶたべました。<br>"
      when "へらしたけれど、ぜんぶたべた"
        "きゅうしょくは へらしたけれど、ぜんぶたべました。<br>"
      when "すこしだけ のこしてしまった"
        "きゅうしょくは すこしだけ のこしてしまいました。<br>"
      else
        ""
      end
    end

    def image_tag_for_emotion(image_url, alt_text)
      if image_url.present?
        "<img src='#{image_url}' alt='#{alt_text}' />"
      else
        ""
      end
    end

    def emotion_class(emotion_num)
      case emotion_num
      when 4 then "emotion-very-smile"
      when 3 then "emotion-smile"
      when 2 then "emotion-normal"
      when 1 then "emotion-shock"
      else "emotion-default"
      end
    end
end
