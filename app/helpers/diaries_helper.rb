# app/helpers/diaries_helper.rb
module DiariesHelper
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
  end
