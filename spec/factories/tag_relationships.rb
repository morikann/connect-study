FactoryBot.define do
  factory :tag_relationship do
    association :profile
    association :tag
  end
end
