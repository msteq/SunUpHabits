FactoryBot.define do
  factory :progress do
    association :habit
    date { Date.today }
    status { '達成' }
  end
end
