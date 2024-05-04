class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.references :session
      t.references :user
      t.integer :row
      t.integer :seat
      t.timestamps
    end
  end
end
