module Accounts
  class ReverseDebit < Accounts::Base
    class NotFound < StandardError; end
    class Forbidden < StandardError; end

    def transfer!(transfer_use_case: Accounts::Transfer.new, token:)
      history = find_history_by!(token: token)
      allow!(history: history)
      transfer_use_case.transfer!({
        from_account: history.to_account,
        to_account: history.from_account,
        value: history.value
      })
    end

    private

    def allow!(history:)
      raise Forbidden.new('Unable to complete this opperation!') unless history.transference?
    end

    def find_history_by!(token:)
      history = History.find_by(token: token)
      raise NotFound.new('Could not find history for this transaction!') if history.blank?
      history
    end
  end
end
