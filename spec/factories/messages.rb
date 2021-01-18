FactoryBot.define do
  factory :message do
    message { 'メッセージ' }
    association :user
    association :room
  end
end
