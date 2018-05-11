class BankAccount < ApplicationRecord
  class InvalidOpperation < StandardError; end

  validates :name, presence: true
  validates :kind, presence: true

  belongs_to :ownerable, polymorphic: true

  has_many :received_transactions, class_name: 'History', foreign_key: 'to_account_id', dependent: :destroy
  has_many :transactions_made, class_name: 'History', foreign_key: 'from_account_id', dependent: :destroy

  has_ancestry

  enum kind: { head_office: 0, subsidiary: 1 }
  enum status: { active: 0, blocked: 1, revoked: 2 }

  def credit!(value)
    self.balance += value
    save!
  end

  def debit!(value)
    raise InvalidOpperation.new('Could not debit value!') if balance < value
    self.balance -= value
    save!
  end
end
