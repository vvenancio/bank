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

  describe '#of_transfer!' do
    context 'when success' do
      let(:from_account) { create(:bank_account) }
      let(:to_account) { create(:bank_account) }

      let(:attributes) do
        {
          to_account_id: to_account.id,
          from_account_id: from_account.id,
          value: 100
        }
      end

      subject { described_class.new.of_transfer!(attributes) }

      it 'creates new resource' do
        expect { subject }.to change(History, :count).by(1)
      end
    end

    context 'when failure' do
      let(:attributes) do
        {
          from_account_id: nil,
          to_account_id: nil,
          value: 10,
        }
      end

      subject { described_class.new.of_transfer!(attributes) }

      it 'does not create new resource' do
        expect { subject }.to raise_error(CreateHistory::InvalidAttributes)
      end
    end
  end
end
