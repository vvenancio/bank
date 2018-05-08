class BankAccount < ApplicationRecord
  validates :name, presence: true
  validates :kind, presence: true

  belongs_to :ownerable, polymorphic: true

  has_ancestry

  enum kind: { head_office: 0, subsidiary: 1 }
  enum status: { active: 0, blocked: 1, revoked: 2 }
end
