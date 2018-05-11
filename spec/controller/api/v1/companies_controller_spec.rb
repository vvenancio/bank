require 'rails_helper'

RSpec.describe Api::V1::CompaniesController, type: :controller do
  let!(:company) { create(:company, name: 'Candy', trade: 'Candy ltda') }

  describe '#create' do
    let(:spy_use_case) { spy 'CreateCompany' }
    let(:attributes) { attributes_for(:company) }

    before do
      allow(controller).to receive(:use_case).and_return(spy_use_case)
      allow(spy_use_case).to receive(:id).and_return(1)
      post :create, params: { company: attributes }
    end

    it 'returns created' do
      body = JSON(response.body)['id']
      expect(response.status).to eq 201
      expect(body).to eq 1
    end

    it 'receives correctly' do
      expect(spy_use_case).to have_received(:create!) do |args|
        expect(args[:name]).to eq attributes[:name]
        expect(args[:cnpj]).to eq attributes[:cnpj]
        expect(args[:trade]).to eq attributes[:trade]
      end
    end
  end

  describe '#show' do
    before { get :show, params: { id: company.id } }

    it 'returns companys JSON' do
      body = JSON(response.body)
      expect(body).to include({
        'id' => company.id,
        'name' => company.name,
        'cnpj' => company.cnpj,
        'trade' => company.trade
      })
    end

    it 'responds ok' do
      expect(response.status).to eq 200
    end
  end

  describe '#update' do
    context 'with valid attributes' do
      before { patch :update, params: { id: company.id, company: { cnpj: '57.274.324/0001-35' } } }

      it 'updates company' do
        company.reload
        expect(company.cnpj).to eq '57.274.324/0001-35'
      end

      it 'responds ok' do
        body = JSON(response.body)['message']
        expect(body).to eq 'Company updated!'
        expect(response.status).to eq 200
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: company.id, company: { name: '' } } }

      it 'does not update company' do
        company.reload
        expect(company.name).to eq 'Candy'
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
end
