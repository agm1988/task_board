# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:tags) }
  end

  it 'has a valid factory' do
    expect(build(:task)).to be_valid
  end

  context 'associations' do
    specify do
      expect(subject).to belong_to(:report)
      expect(subject).to have_one(:author).through(:report)
      expect(subject).to have_many(:taggings)
      expect(subject).to have_many(:tags).through(:taggings)
      expect(subject).to have_many(:comments)
    end
  end
end
