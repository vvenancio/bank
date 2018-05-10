module Accounts
  class Deposit
    class NotAllowedTo < StandardError; end
    class AttributeMissing < StandardError; end

    def initialize(history_use_case: CreateHistory.new)
      @history_use_case = history_use_case
    end

    def deposit!(bank_account_id:, value:)
      raise attribute_missing_exception if value.blank?
      bank_account = find_bank_account(bank_account_id: bank_account_id)

      ActiveRecord::Base.transaction do
        add_money!(bank_account: bank_account, money: value)
        history_use_case.of_deposit!(to_account_id: bank_account_id, value: value)
      end
    end

    private

    attr_reader :history_use_case

    def add_money!(bank_account:, money:)
      raise not_allowed_to_exception unless bank_account.active?
      value = value_to_deposit(value: money)
      bank_account.balance += value
      bank_account.save!
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
