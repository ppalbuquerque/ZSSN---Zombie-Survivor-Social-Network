FactoryGirl.define do
  factory :item do
    name {Faker::Zelda.game}
    points {Faker::Number.number(1)}
  end
end
