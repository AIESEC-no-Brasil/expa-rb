# This module contains the functionality to retrieve
# the details about the current user (current_person,
# as defined in the EXPA API: apidocs.aies.ec)
module EXPA::CurrentPerson
  class << self
    
    # This is the method called to start the process of 
    # retrieving the current_person.
    #
    # Example: 
    #   EXPA::CurrentPerson.get_current_person
    #
    # Returns:
    #   Person
    def get_current_person
      res = get_json
      unless res.nil?
        if res.include?('person')
          res['person'].merge!( {'current_office' => res['current_office'] }) if res.include?('current_office')
          res['person'].merge!( {'current_position' => res['current_position'] }) if res.include?('current_position')
          res['person'].merge!( {'current_teams' => res['current_teams'] }) if res.include?('current_teams')
          Person.new(res['person'])
        end
      end
    end

    private

    # This method retrieves the current user 
    # information from EXPA in the JSON format.
    #
    # Returns:
    #   Hash - Current Person's attributes and values
    def get_json
      params = {}
      params['access_token'] = EXPA.client.get_updated_token
      uri = URI(url_current_person)
      uri.query = URI.encode_www_form(params)
      force_get_response(uri)
    end

    # Retrieves the URL to be used to extract current_person
    # information from EXPA using API.
    #
    # Returns:
    #   String - Current Person URL
    def url_current_person
      $url_api + 'current_person'
    end

    # Sends a GET request to the server and retrives string
    # of attributes and values in String format and the parse
    # it into a Hash of values.
    #
    # Arguments:
    #   String - URI used to send request
    #
    # Returns:
    #   Hash - Attributes and values of Current_Person
    def force_get_response(uri)
      i = 0
      while i < 1000
        begin
		  # This is the line of code we were using before:
		  #   res = Net::HTTP.get(uri)
		  # And below is the code that prevents SSL errors.
		  # begin
		  puts uri
		  req = Net::HTTP::Get.new(uri)
		  res = Net::HTTP.start(
		   			uri.host, uri.port, 
		  			:use_ssl => uri.scheme == 'https', 
		  			:verify_mode => OpenSSL::SSL::VERIFY_NONE) do |https|
		  	  https.request(req)
		  	end
		  res = JSON.parse(res.body) unless res.nil?
		  #end
          i = 1000
        rescue => exception
		  i = 1000 # This prevents the code from running and generating the same exception forever.
		  # In fact, I don't understand the logic behind the 'i' variable. It could be a simple boolean.
          puts exception.to_s
          sleep(i) # Originally, this code would be sleep(0) all the time, so I don't see the point.
        end
      end
      res
    end
  end
end
