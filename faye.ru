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
    if message['channel'] !~ %r{^/meta/}
      if message['ext']['auth_token'] != FAYE_TOKEN
        message['error'] = 'Invalid authentication token'
      end
    end
    callback.call(message)
  end

  # IMPORTANT: clear out the auth token so it is not leaked to the client
  def outgoing(message, callback)
    if message['ext'] && message['ext']['auth_token']
      message['ext'] = {}
    end
    callback.call(message)
  end
end

Faye::WebSocket.load_adapter('thin')

faye_server = Faye::RackAdapter.new(mount: '/faye', timeout: 25)

run faye_server
