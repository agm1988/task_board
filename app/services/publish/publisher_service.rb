# frozen_string_literal: true

module Publish
  class PublisherService
    FAYE_TOKEN = Rails.application.secrets.faye_token
    FAYE_URL = Rails.application.secrets.faye_host

    def self.run(channel, data = nil, &block)
      message_data = block_given? ? capture(&block) : data

      message = { channel: channel, data: message_data, ext: { auth_token: FAYE_TOKEN }}
      uri = URI.parse(FAYE_URL)
      Net::HTTP.post_form(uri, message: message.to_json)
    end
  end
end
