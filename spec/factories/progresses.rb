FactoryBot.define do
  factory :progress do
    association :habit
    date { Date.new(2025, 3, 20) }
    status { '達成' }
  end
end
