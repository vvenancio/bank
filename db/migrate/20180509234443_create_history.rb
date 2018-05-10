class CreateHistory < ActiveRecord::Migration[5.2]
  def change
    create_table :histories do |t|
      t.references :from_account
      t.references :to_account, null: false
      t.integer :kind, default: 0
      t.float :value

      t.timestamps
    end
  end
end
