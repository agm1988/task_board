# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:nickname) }

    it { is_expected.to validate_uniqueness_of(:nickname) }
    it { is_expected.to validate_presence_of(:email) }
  end

  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  context 'associations' do
    specify do
      expect(subject).to have_many(:reports)
      expect(subject).to have_many(:tasks).through(:reports)
    end
  end
end
