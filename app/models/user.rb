# frozen_string_literal: true

class User < ApplicationRecord
  devise(
    :database_authenticatable,
    :registerable,
    :validatable,
    :jwt_authenticatable,
    jwt_revocation_strategy: JwtDenylist
  )

  has_many :places, dependent: :delete_all

  def serializable_hash(options = {})
    options[:except] = [:id, :created_at, :encrypted_password, :updated_at]

    super(options)
  end
end
