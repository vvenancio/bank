class CreateHistory
  class InvalidAttributes < StandardError; end

  def of_deposit!(to_account_id:, value:)
    history = build_deposit_history(to_account_id: to_account_id, value: value)
    history.save!
  rescue ActiveRecord::RecordInvalid => e
    raise InvalidAttributes.new(e.message)
  end

  private

  def build_deposit_history(to_account_id:, value:)
    History.new.tap do |history|
      history.kind = History.kinds[:deposit]
      history.from_account = nil
      history.to_account_id = to_account_id
      history.value = value
    end
  end
end
