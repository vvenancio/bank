class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :cpf
      t.string :name
      t.string :birthdate

      t.timestamps
    end
  end
end
