FactoryBot.define do
  factory :habit do
    association :user
    title { '毎日ランニングする' }
    goal { '体重を3kg減らす' }
    start_date { Date.today }
  end
end
