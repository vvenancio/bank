require 'rails_helper'

RSpec.describe Accounts::Transfer do
  describe 'transfer!' do
    # First tree
    let!(:root_node_1) { create(:bank_account, parent: nil, kind: :head_office) }
    let!(:tree_1_node_1) { create(:bank_account, parent: root_node_1, kind: :subsidiary, balance: 0) }
    let!(:tree_1_node_2) { create(:bank_account, parent: root_node_1, kind: :subsidiary, balance: 10) }
    let!(:tree_1_node_3) { create(:bank_account, parent: tree_1_node_1, kind: :subsidiary, balance: 11.50) }

    # Second tree
    let!(:root_node_2) { create(:bank_account, parent: nil, kind: :head_office) }
    let!(:tree_2_node_1) { create(:bank_account, parent: root_node_2, kind: :subsidiary, balance: 60) }
    let!(:tree_2_node_2) { create(:bank_account, parent: root_node_2, kind: :subsidiary, balance: 9) }

    let(:history_spy) { spy 'CreateHistory' }
    let(:use_case) { described_class.new(history_use_case: history_spy) }

    context 'when accounts are in the same tree' do
      subject { use_case.transfer!(from_account: tree_1_node_3, to_account: tree_1_node_1, value: 10.50) }

      it 'transfer value from account to another' do
        subject
        tree_1_node_3.reload
        tree_1_node_1.reload
        expect(tree_1_node_3.balance).to eq 1.0
        expect(tree_1_node_1.balance).to eq 10.50
      end

      it 'saves transfer history' do
        subject
        expect(history_spy).to have_received(:of_transfer!) do |args|
          expect(args[:from_account_id]).to eq tree_1_node_3.id
          expect(args[:to_account_id]).to eq tree_1_node_1.id
          expect(args[:value]).to eq 10.50
        end
      end
    end

    context 'when accounts are in different tree' do
      subject { use_case.transfer!(from_account: tree_1_node_3, to_account: tree_2_node_1, value: 10.50) }

      it 'rolls back transfering' do
        expect { subject }.to raise_error(Accounts::Transfer::NotAllowedTo)
      end
    end
  end
end
