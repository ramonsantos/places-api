# frozen_string_literal: true

require 'rails_helper'

describe Place, type: :model do
  subject { build(:place) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:reviews).dependent(:delete_all) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:latitude) }
    it { is_expected.to validate_presence_of(:longitude) }
    it { is_expected.to validate_uniqueness_of(:latitude).scoped_to(:longitude) }
  end
end
