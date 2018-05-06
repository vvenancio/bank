require 'rails_helper'

RSpec.describe Api::V1::PeopleController, type: :controller do
  describe '#create' do
    let(:spy_use_case) { spy 'CreatePerson' }

    before do
      allow(controller).to receive(:use_case).and_return(spy_use_case)
      post :create, params: { person: attributes_for(:person) }
    end

    it 'returns created' do
      body = JSON(response.body)['message']
      expect(response.status).to eq 201
      expect(body).to eq 'Person created!'
    end
  end
end
