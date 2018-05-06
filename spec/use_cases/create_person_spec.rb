require 'rails_helper'

RSpec.describe CreatePerson do
  describe '#register!' do
    context 'when success' do
      let(:attributes) do
        {
          cpf: '425.381.112-42',
          birthdate: '29/01/1223',
          name: Faker::Name.name
        }
      end

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
          birthdate: '29-01-1223',
          name: Faker::Name.name
        }
      end

      subject { use_case.register!(attributes) }

      it 'creates new resource' do
        expect { subject }.to raise_error(CreatePerson::InvalidArgument)
      end
    end
  end
end
