require_relative 'offices'

class People

  def initialize(json)
    @id = json['id'].to_i
    @email = json['email']
    @url = URI(json['url'])
    @first_name = json['first_name']
    @birthday_date = json['dob']
    @full_name = json['full_name']
    @last_name = json['last_name']
    @profile_photo_url = URI(json['profile_photo_url'])
    @home_lc = Office.new(json['home_lc'])
    @home_mc = Office.new(json['home_mc'])
    @status = json['status']
    @interviewed = json['interviewed']
    @phone = json['phone']
    @location = json['location']
    @created_at = Time.parse(json['created_at'])
    @updated_at = Time.parse(json['updated_at'])
  end
end

module EXPA::Peoples
  class << self
    def find_by_id(id)

    end

    def list_by_param(params = {})
      peoples = []

      res = find_json(params)
      data = res['data'] unless res.nil?

      for register in data
        peoples << People.new(register)
      end
      peoples
    end

    def list
      peoples = []
      params['per_page'] = 100
      total_pages = self.total_items / params['per_page']

      for i in 1..total_pages
        params['page'] = i
        peoples.concat(self.list_by_param(params))
      end

      for register in data
        peoples << People.new(register)
      end
      peoples
    end

    def get_attributes(id)

    end

    def get_applications(id)

    end

    def list_by_country(country_id, offset = 0, limit = 1000, filters = {})

    end

    def list_by_commitee(committee, offset = 0, limit = 1000, filter = {})

    end

    def total_items
      if @total_items
        @total_items
      else
        begin
          res = find_json
          @total_items = res['paging']['total_items'].to_i unless res.nil?
        end
        @total_items
      end
    end

    #@param status [String]
    def set_filters_status(status)
      @filters[:status] = status
    end

    def clean_filters_status
      @filters.slice!(:status) if @filters.has_key?(:status)
    end

    private

    def find_json(params = {})
      params['access_token'] = EXPA.client.get_updated_token
      params.has_key?('page') or params['page'] = 1
      params.has_key?('per_page') or params['per_page'] = 25

      uri = URI (url_return_all_people)
      uri.query = URI.encode_www_form(params)

      res = Net::HTTP.get(uri)
      JSON.parse(res) unless res.nil?
    end

    def url_return_all_people
      $url_api + 'people'
    end

    def url_view_person_attributes(id)
      url_return_all_people + '/' + id
    end

    def url_get_all_applications_for(id)
      url_view_person_attributes(id) + '/applications'
    end

    def get_filters
      @filters
    end

    def erase_filters
      @filters = nil
    end
  end
end
