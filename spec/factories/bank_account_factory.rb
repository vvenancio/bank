FactoryBot.define do
  factory :bank_account do
    name 'Test name'
    ownerable { create(:person, cpf: CPF.generate(true)) }
  end
end
