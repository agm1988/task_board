# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  it 'has a valid factory' do
    expect(build(:tag)).to be_valid
  end

  context 'associations' do
    specify do
      expect(subject).to have_many(:taggings)
      expect(subject).to have_many(:tasks).through(:taggings)
    end
  end
end
