class History < ApplicationRecord
  validates :kind, presence: true

  belongs_to :from_account, class_name: 'BankAccount', optional: true
  belongs_to :to_account, class_name: 'BankAccount'

  enum kind: { deposit: 0, transference: 1 }

  before_create :set_token

  private

  def set_token
    self.token = SecureRandom.hex(10)
  end
end
