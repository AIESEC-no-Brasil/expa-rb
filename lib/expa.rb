require 'mechanize'
require 'net/http'

require 'expa/version'
require 'expa/client'

require 'expa/models/peoples'
require 'expa/models/offices'
require 'expa/models/applications'

module EXPA
  class << self
    $url_api = 'https://gis-api.aiesec.org:443/v1/'

    def setup
      EXPA.client = EXPA::Client.new()
    end

    def client
      Thread.current[:expa_client]
    end

    def client=(new_client)
      Thread.current[:expa_client] = new_client
    end

    def with_client
      old_client = EXPA.client.try(:dup)
      yield
    ensure
      EXPA.client = old_client
    end

    def connection
      client ? client.connection : nil
    end
  end
end
