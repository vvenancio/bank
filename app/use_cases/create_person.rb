class CreatePerson
  class InvalidAttributes < StandardError; end

  def create!(cpf:, name:, birthdate:)
    instance = build_resource(cpf: cpf, name: name, birthdate: birthdate)
    instance.save!
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidAttributes.new(e.message)
  end

  private

  def build_resource(cpf:, name:, birthdate:)
    Person.new.tap do |person|
      person.cpf = cpf
      person.name = name
      person.birthdate = Date.strptime(birthdate, '%d/%m/%Y')
    end
  end
end
