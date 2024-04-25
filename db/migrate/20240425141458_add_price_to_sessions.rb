class AddPriceToSessions < ActiveRecord::Migration[7.1]
  def change
    add_column :sessions, :price, :float
  end
end
