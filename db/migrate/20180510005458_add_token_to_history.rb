class AddTokenToHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :histories, :token, :string
  end
end
