require 'rails_helper'

RSpec.describe Accounts::Deposit do
  let(:bank_account) { create(:bank_account) }
  let(:use_case) { described_class.new }

  describe '#deposit' do
    context 'when value is provided' do
      before { use_case.deposit!(bank_account_id: bank_account.id, value: 1000.95) }

      it 'deposits value to an account' do
        bank_account.reload
        expect(bank_account.balance).to eq 1000.95
      end

      it 'safe history transaction' do
        bank_account.reload
        transaction = bank_account.received_transactions.first
        expect(transaction.deposit?).to eq true
      end
    end

    context 'when no value provided' do
      it 'raises AttributeMissing' do
        expect {
          use_case.deposit!(bank_account_id: bank_account.id, value: nil)
        }.to raise_error(Accounts::Deposit::AttributeMissing)
      end
    end

    context 'when account is not active' do
      let(:account) { create(:bank_account, status: :revoked) }

      it 'raises NotAllowedTo' do
        expect {
          use_case.deposit!(bank_account_id: account.id, value: 50)
        }.to raise_error(Accounts::Deposit::NotAllowedTo)
      end
    end
  end
end
