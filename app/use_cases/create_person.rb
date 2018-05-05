class CreatePerson
  def initialize(resource: ::Person)
    @resource = resource
  end

  def register!(cpf:, name:, birthdate:)
    instance = build_resource(cpf: cpf, name: name, birthdate: birthdate)
    instance.save!
  rescue ActiveRecord::RecordInvalid => e
    raise GenericErrors::InvalidAttributesException.new(e.message)
  end

  private

  def build_resource(cpf:, name:, birthdate:)
    resource.new.tap do |instance|
      instance.cpf = cpf
      instance.name = name
      instance.birthdate = Date.strptime(birthdate, '%d/%m/%Y')
    end
  end

  attr_accessor :resource
end
