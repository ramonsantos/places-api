# frozen_string_literal: true

class AuthenticationFailureResponder < Devise::FailureApp
  def respond
    self.status = 401
    self.content_type = 'application/json'
    self.response_body = { error: i18n_message.capitalize }.to_json
  end
end
