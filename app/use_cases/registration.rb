class Registration
  def initialize(create_person: CreatePerson.new)
    @create_person = create_person
  end

  def execute!(params = {})
    case
    when params[:cpf].present?
      @create_person.register!(person_parameters(params))
    else
    end
  end

  private

  def person_parameters(params)
    {
      cpf: strip(params[:cpf]),
      name: params[:name],
      birthdate: params[:birthdate]
    }
  end

  def strip(value)
    value.gsub(/[.-]/, '')
  end
end
