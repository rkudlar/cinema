class CreateSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :sessions do |t|
      t.references :movie
      t.references :hall
      t.datetime :start_datetime
      t.jsonb :seats_data, default: {}

      t.timestamps
    end
  end
end
