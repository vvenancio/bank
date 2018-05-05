FactoryBot.define do
  factory :person do
    cpf 42538111242
    name Faker::Name.name
    birthdate Date.today
  end
end
