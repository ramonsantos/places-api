# frozen_string_literal: true

class Place < ApplicationRecord
  acts_as_mappable(
    distance_field_name: :distance,
    lat_column_name: :latitude,
    lng_column_name: :longitude
  )

  belongs_to :user

  validates :user,      presence: true
  validates :name,      presence: true
  validates :latitude,  presence: true, uniqueness: { scope: :longitude }
  validates :longitude, presence: true

  def serializable_hash(options = {})
    options[:except] = [:created_at, :updated_at, :user_id]

    super(options)
  end
end
