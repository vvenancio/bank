class CreateBankAccount < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
      t.string :name
      t.integer :kind
      t.integer :status
      t.float :balance
      t.references :ownerable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
