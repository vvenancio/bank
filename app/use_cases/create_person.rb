class CreatePerson
  class CreatePersonException < StandardError; end

  def initialize(resource: ::Person)
    @resource = resource
  end

  def register!(cpf:, name:, birthdate:)
    instance = build_resource(cpf: cpf, name: name, birthdate: birthdate)
    instance.save!
  rescue => e
    Rails.logger.error({ message: e.message, class: e.class, method: "CreatePerson#Register" })
    raise CreatePersonException.new(e.message)
  end

  private

  def build_resource(cpf:, name:, birthdate:)
    resource.new.tap do |instance|
      instance.cpf = cpf
      instance.name = name
      instance.birthdate = birthdate
    end
  end

  attr_accessor :resource
end
