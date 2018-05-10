require 'rails_helper'

RSpec.describe CreateHistory do
  describe '#of_deposit!' do
    context 'when success' do
      let(:account) { create(:bank_account) }

      let(:attributes) do
        {
          to_account_id: account.id,
          value: 100
        }
      end

      subject { described_class.new.of_deposit!(attributes) }

      it 'creates new resource' do
        expect { subject }.to change(History, :count).by(1)
      end
    end

    context 'when failure' do
      let(:attributes) do
        {
          to_account_id: nil,
          value: 10,
        }
      end

      subject { described_class.new.of_deposit!(attributes) }

      it 'does not create new resource' do
        expect { subject }.to raise_error(CreateHistory::InvalidAttributes)
      end
    end
  end
end
