# This file encapsulates the Client entity and
# the functionality to connect and authenticate
# to EXPA.
module EXPA
  class Client

    # Sets up the environment every time a Client
    # instance is created, e.g. Client.new()
    def initialize

      # URL used to access the authentication form.
      # Open it in your browser if you want details
      @url = 'https://auth.aiesec.org/users/sign_in'
      
      # Every time a user authenticates in EXPA, 
      # a token is generated and stored in the cookies.
      # This class contain functionality to store that 
      # token in this variable.
      @token = nil
      
      #
      @max_age = nil
      
      #
      @expiration_time = nil
    end
    
    # This method authenticates to EXPA using a specific
    # user's credentials and retrieves the token
    # information from cookies.
    #
    # Example:
    #   EXPA::Client.auth('example.user@aiesec.net','example.password')
    #
    # Arguments:
    #   email: (String) - This should be a valid username on EXPA.
    #   password: (String) - The password for the user specified by the email.
    #
    # Returns:
    #   Boolean - Returns true if routine is successful, returns false otherwise.
    #
    def auth(email, password)
      @email = email
      @password = password
      agent = Mechanize.new {|a| a.ssl_version, a.verify_mode = 'TLSv1',OpenSSL::SSL::VERIFY_NONE}
      page = agent.get(@url)
      aiesec_form = page.form()
      aiesec_form.field_with(:name => 'user[email]').value = @email
      aiesec_form.field_with(:name => 'user[password]').value = @password

      begin
        page = agent.submit(aiesec_form, aiesec_form.buttons.first)
      rescue => exception
        puts exception.to_s
        false
      else
        if page.code.to_i == 200
          cj = page.mech.agent.cookie_jar.store
          index = cj.count
          for i in 0...index
            index = i if cj.to_a[i].domain == 'experience.aiesec.org'
          end
          if index != cj.count
            @token = cj.to_a[index].value
            @expiration_time = cj.to_a[index].created_at
            @max_age = cj.to_a[index].max_age
            true
          end
        end
      end
    end

    def get_updated_token
      nil if @email.nil? || @password.nil?

      time = (self.get_expiration_time + (self.get_max_age/2))

      if (Time.now < time)
        self.get_token
      else
        auth(@email, @password)
        self.get_token
      end
    end

    def get_token
      @token
    end

    def get_expiration_time
      @expiration_time = Time.now + 60 if @expiration_time.nil?
      @expiration_time
    end

    def get_max_age
      @max_age = 1800 if @max_age.nil?
      @max_age
    end
  end
end
