class CreateCompany
  class InvalidAttributes < StandardError; end

  def create!(cnpj:, name:, trade:)
    company = build_company(cnpj: cnpj, name: name, trade: trade)
    company.save!
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidAttributes.new(e.message)
  end

  private

  def build_company(cnpj:, name:, trade:)
    Company.new.tap do |person|
      person.cnpj = formatted_cnpj(cnpj)
      person.name = name
      person.trade = trade
    end
  end

  def formatted_cnpj(cnpj)
    CNPJ.new(cnpj).formatted
  end
end
