module EXPA
  class Client

    def initialize
      @url = 'https://auth.aiesec.org/users/sign_in'
      @token = nil
      @expiration_time = Time.now + 60
      @max_age = 1800
    end

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
          cj = agent.cookie_jar
          if !cj.jar['experience.aiesec.org'].nil?
            @token = cj.jar['experience.aiesec.org']['/']['expa_token'].value
            @expiration_time = cj.jar['experience.aiesec.org']['/']['expa_token'].created_at
            @max_age = cj.jar['experience.aiesec.org']['/']['expa_token'].max_age
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
      @expiration_time
    end

    def get_max_age
      @max_age
    end
  end
end
