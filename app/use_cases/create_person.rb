class CreatePerson
  class InvalidAttributes < StandardError; end

  def create!(cpf:, name:, birthdate:)
    person = build_person(cpf: cpf, name: name, birthdate: birthdate)
    person.save!
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidAttributes.new(e.message)
  end

  private

  def build_person(cpf:, name:, birthdate:)
    Person.new.tap do |instance|
      instance.cpf = formatted_cpf(cpf)
      instance.name = name
      instance.birthdate = Date.strptime(birthdate, '%d/%m/%Y')
    end
  end

  def formatted_cpf(cpf)
    CPF.new(cpf).formatted
  end
end
