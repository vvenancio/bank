module Accounts
  class Deposit < Accounts::Base
    class NotAllowedTo < StandardError; end
    class AttributeMissing < StandardError; end

    def deposit!(bank_account_id:, value:)
      raise attribute_missing_exception if value.blank?
      bank_account = find_bank_account(bank_account_id: bank_account_id)

      ActiveRecord::Base.transaction do
        add_money!(bank_account: bank_account, money: value)
        history_use_case.of_deposit!(to_account_id: bank_account_id, value: value)
      end
    end

    private

    def add_money!(bank_account:, money:)
      raise not_allowed_to_exception unless bank_account.active?
      value = value_to_deposit(value: money)
      bank_account.credit!(value)
    end

    def find_bank_account(bank_account_id:)
      BankAccount.find(bank_account_id)
    end

    def value_to_deposit(value:)
      BigDecimal.new(value.to_s)
    end

    def not_allowed_to_exception
      NotAllowedTo.new('Account should be active to receive some deposit!')
    end

    def attribute_missing_exception
      AttributeMissing.new('Deposit value must be provided!')
    end
  end
end
