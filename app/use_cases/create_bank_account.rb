class CreateBankAccount
  class InvalidAttributes < StandardError; end
  class ResourceNotFound < StandardError; end

  def create!(owner:, name:, parent_id: nil)
    bank_account = build_bank_account(owner: owner, name: name, parent_id: parent_id)
    bank_account.save!
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidAttributes.new(e.message)
  end

  private

  def build_bank_account(owner:, name:, parent_id:)
    BankAccount.new.tap do |bank_account|
      bank_account.ownerable = find_owner!(owner: owner)
      bank_account.name = name
      bank_account.kind = BankAccount.kinds[:subsidiary] if parent_id.present?
      bank_account.parent_id = parent_id
    end
  end

  def find_owner!(owner:)
    cpf = formatted_cpf(owner: owner)
    cnpj = formatted_cnpj(owner: owner)
    ownerable = person_or_company(cpf: cpf, cnpj: cnpj)

    if ownerable.blank?
      raise ResourceNotFound.new('Could not find owner!')
    else
      ownerable
    end
  end

  def formatted_cpf(owner:)
    @cpf ||= begin
      cpf = CPF.new(owner)
      cpf.formatted
    end
  end

  def formatted_cnpj(owner:)
    @cnpj ||= begin
      cnpj = CNPJ.new(owner)
      cnpj.formatted
    end
  end

  def person_or_company(cpf:, cnpj:)
    Person.find_by_cpf(cpf) || Company.find_by_cnpj(cnpj)
  end
end
