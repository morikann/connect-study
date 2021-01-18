FactoryBot.define do
  factory :study_event do
    display_range { true }
    name { '勉強会' }
    description { '説明' }
    begin_time { '10:00' }
    finish_time { '11:00' }
    date { '2000-01-01' }
    tag { 'タグ名' }
    association :user
  end
end
