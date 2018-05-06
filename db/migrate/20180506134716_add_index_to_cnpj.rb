class AddIndexToCnpj < ActiveRecord::Migration[5.2]
  def change
    add_index :companies, :cnpj, unique: true
  end
end
