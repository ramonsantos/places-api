class ChangeLatitudeAndLongitudeScaleToPlaces < ActiveRecord::Migration[6.0]
  def up
    change_column :places, :latitude, :decimal, precision: 10, scale: 7, null: false
    change_column :places, :longitude, :decimal, precision: 10, scale: 7, null: false
  end
end
