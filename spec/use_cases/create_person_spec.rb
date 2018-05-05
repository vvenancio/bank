require 'rails_helper'

RSpec.describe CreatePerson do
  describe '#register!' do
    context 'when success' do
      let(:attributes) { attributes_for(:person) }

      subject { described_class.new.register!(attributes) }

      it 'creates new resource' do
        expect { subject }.to change(Person, :count).by(1)
      end
    end

    context 'when failure' do
      let(:person_spy) { spy 'Person' }
      let(:use_case) { described_class.new(resource: spy) }

      let(:attributes) do
        {
          cpf: nil,
          birthdate: '',
          name: Faker::Name.name
        }
      end

      before { allow(person_spy).to receive(:register!).and_raise(StandardError) }

      subject { use_case.register!(attributes) }

      it 'creates new resource' do
        expect { subject }.to change(Person, :count).by(0)
      end
    end
  end
end
