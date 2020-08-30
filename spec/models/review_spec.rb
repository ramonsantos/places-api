# frozen_string_literal: true

require 'rails_helper'

describe Review, type: :model do
  subject { build(:review) }

  describe 'associations' do
    it { is_expected.to belong_to(:place) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:rating) }
    it { is_expected.to validate_inclusion_of(:rating).in_range(1..5).with_message('is not included between 1 and 5') }
    it { is_expected.not_to validate_presence_of(:comment) }
  end

  describe 'scopes' do
    describe 'by_place' do
      let(:marco_zero) { create(:place) }

      before do
        camaragibe = create(:place_camaragibe)
        create(:review, place: marco_zero)
        create(:review, place: camaragibe)
        create(:review, place: marco_zero)
      end

      it 'returns only reviews from "Marco Zero"' do
        expect(described_class.by_place(marco_zero).count).to eq(2)
      end
    end
  end
end
