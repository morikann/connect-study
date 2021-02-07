FactoryBot.define do
  factory :event_user do
    association :user
    association :study_event
  end
end