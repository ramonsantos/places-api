# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :place

  validates :rating,  presence: true, inclusion: { in: 1..5, message: 'is not included between 1 and 5' }
  validates :comment, presence: false

  scope :by_place, ->(place) { where(place: place) }

  def serializable_hash(options = {})
    options[:except] = [:created_at, :place_id, :updated_at]

    super(options)
  end
end
