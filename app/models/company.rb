class Company < ApplicationRecord
  validates :name, presence: true
  validates :cnpj, presence: true, uniqueness: true
  validates :trade, presence: true

  validate :cnpj_format

  has_many :bank_accounts, as: :ownerable, dependent: :destroy

  private

  def cnpj_format
    errors.add(:cnpj, 'is invalid') unless CNPJ.valid?(cnpj)
  end
end
