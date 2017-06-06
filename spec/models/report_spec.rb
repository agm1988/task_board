# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:tasks) }
    it { is_expected.to validate_presence_of(:user) }
  end

  it 'has a valid factory' do
    expect(build(:report)).to be_valid
  end

  context 'associations' do
    specify do
      expect(subject).to belong_to(:user)
      expect(subject).to have_many(:tasks)
      expect(subject).to have_many(:comments)
      expect(subject).to have_many(:task_comments)
    end
  end

  describe 'aasm transitions' do
    specify do
      expect(subject).to transition_from(:draft).to(:reported).on_event(:report)
    end
  end
end
