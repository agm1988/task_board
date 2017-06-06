# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:body) }
  end

  it 'has a valid factory' do
    expect(build(:comment)).to be_valid
  end

  context 'associations' do
    specify do
      expect(subject).to belong_to(:user)
      expect(subject).to belong_to(:commentable)
    end
  end
end
