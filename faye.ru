# frozen_string_literal: true

# require 'faye'
# faye_server = Faye::RackAdapter.new(mount: '/faye', timeout: 25)
# run faye_server

require 'faye'
require 'yaml'
settings = YAML.load_file('config/secrets.yml')
FAYE_TOKEN = settings['production']['faye_token']

class ServerAuth
  def incoming(message, callback)
    message['error'] = 'Invalid authentication token' if invalid_meta?

    callback.call(message)
  end

  # IMPORTANT: clear out the auth token so it is not leaked to the client
  def outgoing(message, callback)
    message['ext'] = {} if message['ext'] && message['ext']['auth_token']

    callback.call(message)
  end

  private

  def invalid_meta?
    message['channel'] !~ %r{^/meta/} && message['ext']['auth_token'] != FAYE_TOKEN
  end
end

Faye::WebSocket.load_adapter('thin')

faye_server = Faye::RackAdapter.new(mount: '/faye', timeout: 25)

run faye_server
