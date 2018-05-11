class AddIndexToToken < ActiveRecord::Migration[5.2]
  def change
    add_index :histories, :token, unique: true
  end
end
