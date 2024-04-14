class AddExternalIdToMovies < ActiveRecord::Migration[7.1]
  def change
    add_column :movies, :external_id, :integer, default: nil
    add_index  :movies, :external_id, unique: true
  end
end
