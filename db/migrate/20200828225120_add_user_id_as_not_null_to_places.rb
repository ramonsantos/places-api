class AddUserIdAsNotNullToPlaces < ActiveRecord::Migration[6.0]
  def up
    change_column :places, :user_id, :bigint, null: false
  end
end
