require_relative 'offices'

class People
  attr_accessor :id
  attr_accessor :email
  attr_accessor :url
  attr_accessor :first_name
  attr_accessor :birthday_date
  attr_accessor :full_name
  attr_accessor :last_name
  attr_accessor :profile_photo_url
  attr_accessor :home_lc
  attr_accessor :home_mc
  attr_accessor :status
  attr_accessor :interviewed
  attr_accessor :phone
  attr_accessor :location
  attr_accessor :created_at
  attr_accessor :updated_at

  def initialize(json)
    self.id = json['id'].to_i unless json['id'].nil?
    self.email = json['email'] unless json['email'].nil?
    self.url = URI(json['url']) unless json['url'].nil?
    self.first_name = json['first_name'] unless json['first_name'].nil?
    self.birthday_date = Date.parse(json['dob'],'%Y-%m-%d') unless json['dob'].nil?
    self.full_name = json['full_name'] unless json['full_name'].nil?
    self.last_name = json['last_name'] unless json['last_name'].nil?
    self.profile_photo_url = URI(json['profile_photo_url']) unless json['profile_photo_url'].nil?
    self.home_lc = Office.new(json['home_lc']) unless json['home_lc'].nil?
    self.home_mc = Office.new(json['home_mc']) unless json['home_mc'].nil?
    self.status = json['status'] unless json['status'].nil?
    self.interviewed = json['interviewed'] unless json['interviewed'].nil?
    self.phone = json['phone'] unless json['phone'].nil?
    self.location = json['location'] unless json['location'].nil?
    self.created_at = Time.parse(json['created_at']) unless json['created_at'].nil?
    self.updated_at = Time.parse(json['updated_at']) unless json['updated_at'].nil?
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
      params = {'per_page' => 100}
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
      params['page'] = 1 unless params.has_key?('page')
      params['per_page'] = 25 unless params.has_key?('per_page')

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
