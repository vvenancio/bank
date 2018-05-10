class BankAccount < ApplicationRecord
  validates :name, presence: true
  validates :kind, presence: true

  belongs_to :ownerable, polymorphic: true

  has_many :received_transactions, class_name: 'History', foreign_key: 'to_account_id'
  has_many :transactions_made, class_name: 'History', foreign_key: 'from_account_id'

  has_ancestry

  enum kind: { head_office: 0, subsidiary: 1 }
  enum status: { active: 0, blocked: 1, revoked: 2 }
end
