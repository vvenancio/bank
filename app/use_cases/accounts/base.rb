module Accounts
  class Base
    def initialize(history_use_case: CreateHistory.new)
      @history_use_case = history_use_case
    end

    protected

    attr_reader :history_use_case
  end
end
