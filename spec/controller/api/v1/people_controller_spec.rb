require 'rails_helper'

RSpec.describe Api::V1::PeopleController, type: :controller do
  let!(:person) { create(:person, name: 'Augusto') }

  describe '#create' do
    let(:spy_use_case) { spy 'CreatePerson' }
    let(:attributes) { attributes_for(:person) }

    before do
      allow(controller).to receive(:use_case).and_return(spy_use_case)
      post :create, params: { person: attributes }
    end

    it 'returns created' do
      body = JSON(response.body)['message']
      expect(response.status).to eq 201
      expect(body).to eq 'Person created!'
    end

    it 'receives correctly' do
      expect(spy_use_case).to have_received(:create!) do |args|
        expect(args[:name]).to eq attributes[:name]
        expect(args[:cpf]).to eq attributes[:cpf]
        expect(args[:birthdate]).to eq attributes[:birthdate].to_s
      end
    end
  end

  describe '#show' do
    before { get :show, params: { id: person.id } }

    it 'returns persons JSON' do
      body = JSON(response.body)
      expect(body).to include({
        'id' => person.id,
        'name' => person.name,
        'cpf' => person.cpf,
        'birthdate' => person.birthdate.to_s
      })
    end

    it 'responds ok' do
      expect(response.status).to eq 200
    end
  end

  describe '#update' do
    context 'with valid attributes' do
      before { patch :update, params: { id: person.id, person: { cpf: '329.328.643-78' } } }

      it 'updates person' do
        person.reload
        expect(person.cpf).to eq '329.328.643-78'
      end

      it 'responds ok' do
        body = JSON(response.body)['message']
        expect(body).to eq 'Person updated!'
        expect(response.status).to eq 200
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: person.id, person: { name: '' } } }

      it 'does not updates person' do
        person.reload
        expect(person.name).to eq 'Augusto'
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
