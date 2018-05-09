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
      post :create, params: { bank_account: attributes }
    end

    it 'returns created' do
      body = JSON(response.body)['message']
      expect(response.status).to eq 201
      expect(body).to eq 'Bank account created!'
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
  end
end
