class AddIndexToCpf < ActiveRecord::Migration[5.2]
  def change
    add_index :people, :cpf, unique: true
  end
end
