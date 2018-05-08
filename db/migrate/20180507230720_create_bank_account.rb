class CreateBankAccount < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
      t.string :name
      t.integer :kind, default: 0
      t.integer :status, default: 0
      t.float :balance, default: 0.0
      t.references :ownerable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
