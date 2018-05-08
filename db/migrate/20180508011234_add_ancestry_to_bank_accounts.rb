class AddAncestryToBankAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :bank_accounts, :ancestry, :string
    add_index :bank_accounts, :ancestry
  end
end
