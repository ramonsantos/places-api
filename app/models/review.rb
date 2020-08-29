# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :place

  validates :rating,  presence: true, inclusion: { in: 1..5, message: 'is not included between 1 and 5' }
  validates :comment, presence: false

  def serializable_hash(options = {})
    options[:except] = [:created_at, :updated_at, :place_id]

    super(options)
  end
end
