require 'rails_helper'

RSpec.describe CreateCompany do
  describe '#create!' do
    context 'when success' do
      let(:attributes) do
        {
          cnpj: '16.573.627/0001-71',
          trade: 'Mega ltda',
          name: 'Mega'
        }
      end

      subject { described_class.new.create!(attributes) }

      it 'creates new resource' do
        expect { subject }.to change(Company, :count).by(1)
      end
    end

    context 'when failure' do
      let(:attributes) do
        {
          cnpj: '',
          trade: 'Mega ltda',
          name: 'Mega'
        }
      end

      subject { described_class.new.create!(attributes) }

      it 'does not create new resource' do
        expect { subject }.to raise_error(CreateCompany::InvalidAttributes)
      end
    end
  end
end
