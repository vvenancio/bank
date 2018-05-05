require 'rails_helper'

RSpec.describe Registration do
  describe '#execute!' do
    let(:create_person_spy) { spy 'CreatePerson' }
    let(:registration) { described_class.new(create_person: create_person_spy) }

    context 'when cpf is present' do
      let(:name) { Faker::Name.name }
      let(:today) { Date.today.to_s }

      let(:params) do
        {
          cpf: '803.195.585-92',
          birthdate: today,
          name: name
        }
      end

      subject { registration.execute!(params) }

      it 'calls create_person' do
        subject
        expect(create_person_spy).to have_received(:register!) do |args|
          expect(args[:cpf]).to eq '80319558592'
          expect(args[:name]).to eq name
          expect(args[:birthdate]).to eq today
        end
      end
    end
  end
end
