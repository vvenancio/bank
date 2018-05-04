class CreateCompanies < ActiveRecord::Migration[5.2]
  def change
    create_table :companies do |t|
      t.string :cnpj
      t.string :name
      t.string :trade

      t.timestamps
    end
  end
end
