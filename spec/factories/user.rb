FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "email#{n}@test.com" }
    password { '123asdQQ' }
  end

  trait :with_videos do
    after(:create) do |user|
      create_list(:video, 3, user: user)
    end
  end
end
