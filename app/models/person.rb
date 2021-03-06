class Person < ApplicationRecord
  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true
  validates :birthdate, presence: true

  validate :cpf_format

  has_many :bank_accounts, as: :ownerable, dependent: :destroy

  private

  def cpf_format
    errors.add(:cpf, 'is invalid') unless CPF.valid?(cpf)
  end
end
