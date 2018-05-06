class CreatePerson
  class InvalidAttributes < StandardError; end

  def register!(cpf:, name:, birthdate:)
    instance = build_resource(cpf: cpf, name: name, birthdate: birthdate)
    instance.save!
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidAttributes.new(e.message)
  end

  private

  def build_resource(cpf:, name:, birthdate:)
    Person.new.tap do |instance|
      instance.cpf = strip(cpf)
      instance.name = name
      instance.birthdate = Date.strptime(birthdate, '%d/%m/%Y')
    end
  end

  def strip(cpf)
    cpf && cpf.gsub(/[.-]/, '')
  end

  attr_accessor :resource
end
