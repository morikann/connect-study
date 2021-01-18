FactoryBot.define do
  factory :profile do
    username { 'ゲストユーザー' }
    purpose { 'ポートフォリオの閲覧' }
    prefecture_id { 10 }
    birth_date { '2000/01/01' }
    tag { 'プログラミング' }
    association :user

    # 無効になっている
    trait :invalid do
      username { nil }
    end
  end
end
