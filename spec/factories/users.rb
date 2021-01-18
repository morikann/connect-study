FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "example#{n+1}@example.com" }
    password { "password" }

    # 管理ユーザー
    trait :admin do
      admin { true }
    end
  end
end
