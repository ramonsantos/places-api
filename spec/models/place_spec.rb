# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Place, type: :model do
  describe 'validations' do
    context 'when presense_of true' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:latitude) }
      it { is_expected.to validate_presence_of(:longitude) }
    end
  end
end
