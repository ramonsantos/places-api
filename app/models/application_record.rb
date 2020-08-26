# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def serializable_hash(options = {})
    options[:except] = [:created_at, :updated_at, :user_id]

    super(options)
  end
end
