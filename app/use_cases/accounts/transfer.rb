module Accounts
  class Transfer < Accounts::Base
    class NotAllowedTo < StandardError; end

    def transfer!(from_account:, to_account:, value:)
      allow!(from_account: from_account, to_account: to_account)

      ActiveRecord::Base.transaction do
        from_account.debit!(value)
        to_account.credit!(value)
        history_use_case.of_transfer!(from_account_id: from_account.id, to_account_id: to_account.id, value: value)
      end
    end

    private

    def allow!(from_account:, to_account:)
      raise not_allowed_to_exception unless node_of_tree?(root: from_account.root, to_account: to_account)
    end

    def node_of_tree?(root:, to_account:)
      root.descendants.where(id: to_account.id).any?
    end

    def not_allowed_to_exception
      NotAllowedTo.new('Accounts must be from the same tree!')
    end
  end
end
