FactoryBot.define do
  factory :post do
    association :user
    association :habit
    content { "これはサンプルの投稿内容です" }
  end
end
