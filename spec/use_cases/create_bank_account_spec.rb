require 'rails_helper'

RSpec.describe CreateBankAccount do
  describe '#create!' do
    let(:account) { BankAccount.last }
    let!(:person) { create(:person, cpf: '425.381.112-42') }

    context 'when no parent_id is passed' do

      let(:attributes) do
        {
          owner: '42538111242',
          name: 'Mega'
        }
      end

      subject { described_class.new.create!(attributes) }

      it 'creates a new head_office account' do
        subject
        expect(account.head_office?).to eq true
      end

      it 'creates new resource' do
        expect { subject }.to change(BankAccount, :count).by(1)
      end

      it 'associates company' do
        subject
        expect(account.ownerable).to eq person
      end
    end

    context 'when parent_id is passed' do
      let!(:head_office) { create(:bank_account) }

      let(:attributes) do
        {
          owner: '42538111242',
          name: 'Mega',
          parent_id: head_office.id
        }
      end

      subject { described_class.new.create!(attributes) }

      it 'creates a new subsidiary account' do
        subject
        expect(account.subsidiary?).to eq true
        expect(account.root).to eq head_office
      end

      it 'creates new resource' do
        expect { subject }.to change(BankAccount, :count).by(1)
      end

      it 'associates company' do
        subject
        expect(account.ownerable).to eq person
      end
    end

    context 'when owner is a company' do
      let!(:company) { create(:company, cnpj: '16.573.627/0001-71') }

      let(:attributes) do
        {
          owner: '16573627000171',
          name: 'Mega'
        }
      end

      subject { described_class.new.create!(attributes) }

      it 'creates new resource' do
        expect { subject }.to change(BankAccount, :count).by(1)
      end

      it 'associates company' do
        subject
        expect(account.ownerable).to eq company
      end

      it 'associates company' do
        subject
        expect(account.ownerable).to eq company
      end
    end

    xcontext 'when failure' do
      let(:attributes) do
        {
          cnpj: '',
          trade: 'Mega ltda',
          name: 'Mega'
        }
      end

      subject { described_class.new.create!(attributes) }

      it 'does not creates new resource' do
        expect { subject }.to raise_error(CreateCompany::InvalidAttributes)
      end
    end
  end
end
