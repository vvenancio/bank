require 'rails_helper'

RSpec.describe Accounts::ReverseDebit do
  describe '#transfer!' do
    let(:use_case) { described_class.new }
    let(:transfer_spy) { spy 'CreateTransfer' }
    let(:from_account) { create(:bank_account) }
    let(:to_account) { create(:bank_account) }

    context 'when success' do
      let(:history) do
        create :history,
               from_account: from_account,
               to_account: to_account,
               kind: :transference,
               value: 10
      end

      before { use_case.transfer!(transfer_use_case: transfer_spy, token: history.token) }

      it 'rolls back transfer' do
        expect(transfer_spy).to have_received(:transfer!) do |args|
          expect(args[:from_account]).to eq to_account
          expect(args[:to_account]).to eq from_account
          expect(args[:value]).to eq 10
        end
      end
    end

    context 'when no history found' do
      let(:token) { SecureRandom.hex(10) }

      subject { use_case.transfer!(token: token) }

      it 'raises Accounts::ReverseDebit::NotFound' do
        expect { subject }.to raise_error(Accounts::ReverseDebit::NotFound)
      end
    end

    context 'when no transference history found' do
      let(:history) do
        create :history,
               from_account: from_account,
               to_account: to_account,
               kind: :deposit,
               value: 10
      end

      subject { use_case.transfer!(token: history.token) }

      it 'raises Accounts::ReverseDebit::Forbidden' do
        expect { subject }.to raise_error(Accounts::ReverseDebit::Forbidden)
      end
    end
  end
end
