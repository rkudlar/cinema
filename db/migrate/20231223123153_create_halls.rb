class CreateHalls < ActiveRecord::Migration[7.1]
  def change
    create_table :halls do |t|
      t.string :name
      t.jsonb :scheme, default: {}

      t.timestamps
    end
  end
end
