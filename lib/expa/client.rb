require 'mechanize'

module EXPA
  class Client

    def initialize(options = {})
      @url = 'https://auth.aiesec.org/users/sign_in'
      @token = nil
      @expiration_time = nil
      @max_age = nil
    end

    def auth(email, password)
      agent = Mechanize.new
      page = agent.get(@url)
      aiesec_form = page.form()
      aiesec_form.field_with(:name => 'user[email]').value = email
      aiesec_form.field_with(:name => 'user[password]').value = password

      begin
        page = agent.submit(aiesec_form, aiesec_form.buttons.first)
      rescue => exception
        puts exception.to_s
      else
        if page.code.to_i == 200
          cj = agent.cookie_jar
          if !cj.jar['experience.aiesec.org'].nil?
            @token = cj.jar['experience.aiesec.org']['/']['expa_token'].value
            @expiration_time = cj.jar['experience.aiesec.org']['/']['expa_token'].created_at
            @max_age = cj.jar['experience.aiesec.org']['/']['expa_token'].max_age
          end
        end
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
