require 'mechanize'
require 'net/http'

require 'expa/version'
require 'expa/client'

# These files contain the routines to retrieve specific
# entities from EXPA. All of them use the authentication
# routine defined by the EXPA::Client class.
require 'expa/models/applications'
require 'expa/models/offices'
require 'expa/models/opportunities'
require 'expa/models/people'
require 'expa/models/programmes'
require 'expa/models/current_person'

module EXPA
  
  class << self

    # URL used to connect to EXPA API. Currently using 
    # version 2 of the API. If you need to check more 
    # details, please access apidocs.aies.ec
    $url_api = 'https://gis-api.aiesec.org/v2/'

    # Creates an instance of Client that will be used for
    # authentication.
    # 
    # Example:
    #   client = EXPA.setup()
    #  
    # Returns:
    #    EXPA::Client
    def setup
      if EXPA.client.nil?
	    # Sets the client variable in the EXPA module
		# which can be used for authentication afterwards
        EXPA.client = EXPA::Client.new()
      end
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
