require 'rails_helper'

RSpec.describe Api::V1::BankAccountsController, type: :controller do
  let!(:bank_account) { create(:bank_account, name: 'NA') }

  describe '#create' do
    let(:spy_use_case) { spy 'CreateBankAccount' }
    let(:person) { create(:person) }

    let(:attributes) do
      {
        parent_id: '',
        name: 'Ltda',
        owner: person.cpf
      }
    end

    before do
      allow(controller).to receive(:use_case).and_return(spy_use_case)
      allow(spy_use_case).to receive(:id).and_return(1)
      post :create, params: { bank_account: attributes }
    end

    it 'returns created' do
      body = JSON(response.body)['id']
      expect(response.status).to eq 201
      expect(body).to eq 1
    end

    it 'receives correctly' do
      expect(spy_use_case).to have_received(:create!) do |args|
        expect(args[:name]).to eq attributes[:name]
        expect(args[:owner]).to eq attributes[:owner]
        expect(args[:parent_id]).to eq attributes[:parent_id]
      end
    end
  end

  describe '#show' do
    before { get :show, params: { id: bank_account.id } }

    it 'returns persons JSON' do
      body = JSON(response.body)
      expect(body).to include({
        'id' => bank_account.id,
        'name' => bank_account.name,
        'owner' => bank_account.ownerable.name,
        'children' => [],
        'kind' => 'head_office'
      })
    end

    it 'responds ok' do
      expect(response.status).to eq 200
    end
  end

  describe '#update' do
    context 'with valid attributes' do
      before { patch :update, params: { id: bank_account.id, bank_account: { name: 'Mazaroppi ltda' } } }

      it 'updates bank_account' do
        bank_account.reload
        expect(bank_account.name).to eq 'Mazaroppi ltda'
      end

      it 'responds ok' do
        body = JSON(response.body)['message']
        expect(body).to eq 'Bank account updated!'
        expect(response.status).to eq 200
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: bank_account.id, bank_account: { name: '' } } }

      it 'does not updates bank_account' do
        bank_account.reload
        expect(bank_account.name).to eq 'NA'
      end

      it 'responds bad_request' do
        expect(response.status).to eq 400
      end

      it 'fills response body' do
        arry = JSON(response.body)['error']
        expect(JSON(arry)).to be_a Array
      end
    end
  end

  describe '#deposit' do
    context 'when value is provided' do
      before { post :deposit, params: { id: bank_account.id, value: 1000.95 } }

      it 'deposits value to an account' do
        bank_account.reload
        expect(bank_account.balance).to eq 1000.95
      end

      it 'returns no_content' do
        expect(response.status).to eq 204
      end
    end

    context 'when no value provided' do
      before { post :deposit, params: { id: bank_account.id, value: nil } }

      it 'returns bad_request' do
        expect(response.status).to eq 400
      end
    end

    context 'when account is not active' do
      let(:account) { create(:bank_account, status: :revoked) }

      before { post :deposit, params: { id: account.id, value: 50 } }

      it 'returns forbidden' do
        expect(response.status).to eq 403
      end
    end
  end

  describe '#transfer' do
    let(:transfer_spy) { spy 'Transfer' }

    context 'when no failure' do
      before do
        allow(controller).to receive(:transference_use_case).and_return(transfer_spy)
        allow(transfer_spy).to receive(:token).and_return(SecureRandom.hex(10))
        post :transfer, params: { from_account_id: bank_account.id, to_account_id: bank_account.id, value: 1000.95 }
      end

      it 'returns ok' do
        expect(response.status).to eq 200
      end
    end

    context 'when failure' do
      before do
        allow(controller).to receive(:transference_use_case).and_return(transfer_spy)
        allow(transfer_spy).to receive(:transfer!).and_raise(Accounts::Transfer::NotAllowedTo)
        post :transfer, params: { from_account_id: bank_account.id, to_account_id: bank_account.id, value: 1000.95 }
      end

      it 'returns forbidden' do
        expect(response.status).to eq 403
      end
    end
  end
end
