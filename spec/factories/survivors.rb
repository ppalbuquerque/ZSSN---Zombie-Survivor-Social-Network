FactoryGirl.define do
  factory :survivor do
    name {Faker::Zelda.character}
    age {Faker::Number.number(2)}
    gender {Faker::Color.color_name}
    last_x {Faker::Number.decimal(2, 3)}
    last_y {Faker::Number.decimal(2, 3)}
    report_infected {0}
  end

end
