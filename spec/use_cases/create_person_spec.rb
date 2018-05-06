require 'rails_helper'

RSpec.describe CreatePerson do
  describe '#create!' do
    context 'when success' do
      let(:attributes) do
        {
          cpf: '425.381.112-42',
          birthdate: '29/01/1223',
          name: Faker::Name.name
        }
      end

      subject { described_class.new.create!(attributes) }

      it 'creates new resource' do
        expect { subject }.to change(Person, :count).by(1)
      end
    end

    context 'when failure' do
      let(:attributes) do
        {
          cpf: nil,
          birthdate: '29/01/1223',
          name: Faker::Name.name
        }
      end

      subject { described_class.new.create!(attributes) }

      it 'creates new resource' do
        expect { subject }.to raise_error(CreatePerson::InvalidAttributes)
      end
    end
  end
end
