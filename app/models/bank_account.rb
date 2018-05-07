class BankAccount < ApplicationRecord
  validates :name, presence: true
  validates :kind, presence: true

  belongs_to :ownerable, polymorphic: true
end
