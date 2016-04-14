module EXPA::CurrentPerson
  class << self
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