FactoryBot.define do
  factory :study_event do
    display_range { false }
    name { 'プログラミング勉強会' }
    description { '説明' }
    begin_time { '10:00' }
    finish_time { '11:00' }
    date { '2000-01-01' }
    tag { 'タグ名' }
    association :user

    # 公開範囲がフォロワーのみになっている
    trait :private do
      display_range { true }
    end
  end
end
