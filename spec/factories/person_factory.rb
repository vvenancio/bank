FactoryBot.define do
  factory :person do
    cpf '425.381.112-42'
    name Faker::Name.name
    birthdate '05/06/2018'
  end
end
