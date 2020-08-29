# frozen_string_literal: true

require 'rails_helper'

describe Review, type: :model do
  subject { build(:review) }

  context 'associations' do
    it { is_expected.to belong_to(:place) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:rating) }
    it { is_expected.to validate_inclusion_of(:rating).in_range(1..5).with_message('is not included between 1 and 5') }
    it { is_expected.not_to validate_presence_of(:comment) }
  end
end
