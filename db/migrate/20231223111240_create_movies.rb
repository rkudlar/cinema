class CreateMovies < ActiveRecord::Migration[7.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.string :description
      t.string :genre, array: true, default: []
      t.integer :duration
      t.string :directors, array: true, default: []
      t.string :actors, array: true, default: []
      t.string :countries, array: true, default: []
      t.date :release_date
      t.timestamps
    end
  end
end
