module EXPA::CurrentPerson
  class << self
    def get_current_person
      res = get_json
      data = res['person'] unless res.nil?
      Person.new(data) unless data.nil?
    end

    private

    def get_json
      params = {}
      params['access_token'] = EXPA.client.get_updated_token

      uri = URI(url_current_person)
      uri.query = URI.encode_www_form(params)

      force_get_response(uri)
    end

    def url_current_person
      $url_api + 'current_person'
    end

    def force_get_response(uri)
      i = 0
      while i < 1000
        begin
          res = Net::HTTP.get(uri)
          res = JSON.parse(res) unless res.nil?
          i = 1000
        rescue => exception
          puts exception.to_s
          sleep(i)
        end
      end
      res
    end
  end
end