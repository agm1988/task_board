# frozen_string_literal: true

shared_examples 'has success response' do
  describe 'response should be success' do
    specify do
      expect(response).to be_success
    end
  end
end
