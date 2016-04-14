require_relative 'current_position'
require_relative 'offices'

class Person
  # Data that comes at the lists
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

  # Adittional data that comes at the get attributes
  attr_accessor :middles_names
  attr_accessor :introduction
  attr_accessor :aiesec_email
  attr_accessor :payment
  attr_accessor :programmes
  attr_accessor :views
  attr_accessor :favourites_count
  attr_accessor :contacted_at
  attr_accessor :contacted_by
  attr_accessor :gender
  attr_accessor :address_info
  attr_accessor :contact_info
  attr_accessor :current_office
  attr_accessor :cv_info
  attr_accessor :profile_photos_urls
  attr_accessor :cover_photo_urls
  attr_accessor :teams
  attr_accessor :positions
  attr_accessor :profile
  attr_accessor :academic_experience
  attr_accessor :professional_experience
  attr_accessor :managers
  attr_accessor :missing_profile_fields
  attr_accessor :nps_score
  attr_accessor :current_experience
  attr_accessor :permissions
  attr_accessor :current_position



  def initialize(json)
    #TODO: Certify every field is receiving the right information type when getting attributes
    # Data that comes at the lists
    self.id = json['id'] unless json['id'].nil?
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

    # Adittional data that comes at the get attributes
    self.middles_names = json['middles_names'] unless json['middles_names'].nil?
    self.introduction = json['introduction'] unless json['introduction'].nil?
    self.aiesec_email = json['aiesec_email'] unless json['aiesec_email'].nil?
    self.payment = json['payment'] unless json['payment'].nil?
    self.programmes = json['programmes'] unless json['programmes'].nil?
    self.views = json['views'] unless json['views'].nil?
    self.favourites_count = json['favourites_count'] unless json['favourites_count'].nil?
    self.contacted_at = Time.parse(json['contacted_at']) unless json['contacted_at'].nil?
    #self.contacted_by = EXPA::Peoples.find_by_id(json['contacted_by']) unless json['contacted_by'].nil?
    self.gender = json['gender'] unless json['gender'].nil?
    self.address_info = json['address_info'] unless json['address_info'].nil? #TODO struct
    self.contact_info = json['contact_info'] unless json['contact_info'].nil? #TODO struct
    self.current_office = Office.new(json['current_office']) unless json['current_office'].nil?
    self.cv_info = json['cv_info'].to_json unless json['cv_info'].nil?
    self.profile_photos_urls = json['profile_photos_urls'] unless json['profile_photos_urls'].nil?
    self.cover_photo_urls = URI(json['cover_photo_urls']) unless json['cover_photo_urls'].nil?
    self.teams = json['teams'] unless json['teams'].nil? #TODO struct
    self.positions = json['positions'] unless json['positions'].nil?
    self.profile = json['profile'] unless json['profile'].nil? #TODO struct
    self.academic_experience = json['academic_experience'] unless json['academic_experience'].nil? #TODO struct
    self.professional_experience = json['professional_experience'] unless json['professional_experience'].nil? #TODO struct
    self.managers = json['managers'] unless json['managers'].nil? #TODO struct
    self.missing_profile_fields = json['missing_profile_fields'] unless json['missing_profile_fields'].nil?
    self.nps_score = json['nps_score'] unless json['nps_score'].nil?
    self.current_experience = json['current_experience'] unless json['current_experience'].nil?
    self.permissions = json['permissions'].to_json unless json['permissions'].nil? #TODO struct
    self.current_position = CurrentPosition.new(json['current_position']) unless json['current_position'].nil?
    unless self.current_position.nil?
      puts 'oi'
    end
  end
end

module EXPA::People
  class << self
    #EXPA only accepts the following filters['status']: 'open', 'in progress', 'matched', 'realized', 'completed'
    def list_by_param(params = {})
      peoples = []

      res = list_json(params)
      data = res['data'] unless res.nil?

      data.each do |item|
        peoples << Person.new(item)
      end

      peoples
    end

    # This method was not tested because it would take too long to download the whole peoples database from EXPA. But this methods uses other methods that are tested
    def list_all
      peoples = []
      params = {'per_page' => 100}
      items = total_items
      total_pages = items / params['per_page']
      total_pages = total_pages + 1 if items % params['per_page'] > 0

      for i in 1...total_pages
        params['page'] = i
        peoples.concat(list_by_param(params))
      end

      peoples
    end

    def list_everyone_created_after(time, params = {})
      peoples = []
      params['per_page'] = 25
      total_pages = total_items / params['per_page']
      total_pages = total_pages + 1 if total_items % params['per_page'] > 0

      for i in 1..total_pages
        params['page'] = i
        peoples.concat(list_by_param(params))
        break if peoples.last.created_at < time
      end

      peoples.delete_if do |person|
        person.created_at < time
      end

      peoples
    end

    def find_by_id(id)
      get_attributes(id)
    end

    def get_attributes(id)
      res = get_attribute_json(id)
      Person.new(res) unless res.nil?
    end

    def list_applications_by_id(id)
      get_applications(id)
    end

    def get_applications(id)
      applications = []

      params = {'per_page' => 100}
      total_pages = total_applications_from_person(id) / params['per_page']
      total_pages = total_pages + 1 if total_applications_from_person(id) % params['per_page'] > 0

      for i in 1..total_pages
        params['page'] = i
        res = get_applications_json(id, params)
        data = res['data'] unless res.nil?

        data.each do |item|
          applications << Application.new(item)
        end
      end

      applications
    end

    def total_items(params = {})
      res = list_json(params)
      res['paging']['total_items'].to_i unless res.nil?
    end

    def total_applications_from_person(id, params = {})
      res = get_applications_json(id, params)
      res['paging']['total_items'].to_i unless res.nil?
    end

    private

    def list_json(params = {})
      params['access_token'] = EXPA.client.get_updated_token
      params['page'] = 1 unless params.has_key?('page')
      params['per_page'] = 25 unless params.has_key?('per_page')

      uri = URI(url_return_all_people)
      uri.query = URI.encode_www_form(params)

      force_get_response(uri)
    end

    def get_attribute_json(id)
      params = {}
      params['access_token'] = EXPA.client.get_updated_token
      params['person_id'] = id

      uri = URI(url_view_person_attributes(id))
      uri.query = URI.encode_www_form(params)

      force_get_response(uri)
    end

    def get_applications_json(id, params = {})
      params['access_token'] = EXPA.client.get_updated_token
      params['person_id'] = id
      params['page'] = 1 unless params.has_key?('page')
      params['per_page'] = 25 unless params.has_key?('per_page')

      uri = URI(url_get_all_applications_for(id))
      uri.query = URI.encode_www_form(params)

      force_get_response(uri)
    end

    def url_return_all_people
      $url_api + 'people'
    end

    def url_view_person_attributes(id)
      url_return_all_people + '/' + id.to_s
    end

    def url_get_all_applications_for(id)
      url_view_person_attributes(id) + '/applications'
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
