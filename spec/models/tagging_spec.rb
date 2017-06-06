# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tagging, type: :model do
  context 'associations' do
    specify do
      expect(subject).to belong_to(:tag)
      expect(subject).to belong_to(:task)
    end
  end
end
