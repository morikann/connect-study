FactoryBot.define do
  factory :location do
    name { '場所' }
    address { '住所' }
    prefecture_id { 20 }
    latitude { 1.1 }
    longitude { 1.1 }
    association :study_event

    # 無効な住所で緯度、経度が取得できない時
    trait :invalid_address do
      latitude { nil }
      longitude { nil }
    end
  end
end
