# frozen_string_literal: true

require 'rails_helper'

describe User, type: :model do
  context 'associations' do
    it { is_expected.to have_many(:places).dependent(:delete_all) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.not_to validate_presence_of(:places) }
  end
end
