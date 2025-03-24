FactoryBot.define do
  factory :comment do
    association :user
    association :post
    content { "これはサンプルのコメントです" }
  end
end
