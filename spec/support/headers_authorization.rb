# frozen_string_literal: true

require 'devise/jwt/test_helpers'

module HeadersAuthorization
  def headers_authorization(user)
    headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
    @request.headers.merge!(Devise::JWT::TestHelpers.auth_headers(headers, user))
  end
end
