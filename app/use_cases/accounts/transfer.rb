module Accounts
  class Transfer < Accounts::Base
    class NotAllowedTo < StandardError; end

    def transfer!(from_account:, to_account:, value:)
      allow!(from_account: from_account, to_account: to_account)
      money = value_to_transfer(value: value)
      ActiveRecord::Base.transaction do
        from_account.debit!(money)
        to_account.credit!(money)
        history_use_case.of_transfer!({
          from_account_id: from_account.id,
          to_account_id: to_account.id,
          value: value
        })
      end
    end

    private

    def value_to_transfer(value:)
      BigDecimal.new(value.to_s)
    end

    def allow!(from_account:, to_account:)
      raise not_allowed_to_exception unless allow?(from_account: from_account, to_account: to_account)
    end

    def node_of_tree?(root:, to_account:)
      root.descendants.where(id: to_account.id).any?
    end

    def not_allowed_to_exception
      NotAllowedTo.new('Operation not allowed to be completed!')
    end

    def allow?(from_account:, to_account:)
      node_of_tree?(root: from_account.root, to_account: to_account) &&
      (to_account.active? && from_account.active?) &&
      (!to_account.head_office? && !from_account.head_office?)
    end
  end
end
