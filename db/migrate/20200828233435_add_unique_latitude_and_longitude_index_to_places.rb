class AddUniqueLatitudeAndLongitudeIndexToPlaces < ActiveRecord::Migration[6.0]
  def change
    remove_index :places, name: :index_places_on_latitude_and_longitude
    add_index :places, [:latitude, :longitude], unique: true
  end
end
