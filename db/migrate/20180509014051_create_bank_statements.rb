class CreateBankStatements < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_statements do |t|
      t.integer :operation
      t.string :code
      t.float :value
      t.references :bank_account, foreign_key: true

      t.timestamps
    end
  end
end
