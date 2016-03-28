require_relative 'opportunities'

class Application
  # Data that comes at the lists from people
  attr_accessor :id
  attr_accessor :url
  attr_accessor :matchability
  attr_accessor :status
  attr_accessor :current_status
  attr_accessor :favourite
  attr_accessor :permissions
  attr_accessor :created_at
  attr_accessor :updated_at
  attr_accessor :opportunity
  attr_accessor :interviewed
  attr_accessor :person

  def initialize(json)
    self.id = json['id'].to_i unless json['id'].nil?
    self.url = URI(json['url']) unless json['url'].nil?
    self.matchability = json['matchability'] unless json['matchability'].nil?
    self.status = json['status'] unless json['status'].nil?
    self.current_status = json['current_status'] unless json['current_status'].nil?
    self.favourite = json['favourite'] unless json['favourite'].nil?
    self.permissions = json['permissions'].to_json.to_s unless json['permissions'].nil?
    self.created_at = Time.parse(json['created_at']) unless json['created_at'].nil?
    self.updated_at = Time.parse(json['updated_at']) unless json['updated_at'].nil?
    self.opportunity = Opportunity.new(json['opportunity']) unless json['opportunity'].nil?
    self.interviewed = json['interviewed'] unless json['interviewed'].nil?
    #self.paid_at
    #self.paid_by
    self.person = Person.new(json['person']) unless json['person'].nil?
    #self.branch # TODO Struct
    #self.an_signed_at
    #self.experience_start_date
    #self.experience_end_date
    #self.matched_or_rejected_at
    #self.meta
  end
end

module EXPA::Applications
  class << self
    def list_by_param(params = {})
      applications = []

      res = list_json(params)
      data = res['data'] unless res.nil?

      data.each do |item|
        applications << Application.new(item)
      end

      applications
    end

    def list_all
      applications = []
      params = {'per_page' => 100}
      items = total_items
      total_pages = items / params['per_page']
      total_pages = total_pages + 1 if items % params['per_page'] > 0

      for i in 1...total_pages
        params['page'] = i
        applications.concat(list_by_param(params))
      end

      applications
    end

    def find_by_id(id)
      get_attributes(id)
    end

    def get_attributes(id)
      res = get_attribute_json(id)
      Application.new(res) unless res.nil?
    end

    def total_items(params = {})
      res = list_json(params)
      res['paging']['total_items'].to_i unless res.nil?
    end

    private

    def list_json(params = {})
      params['access_token'] = EXPA.client.get_updated_token
      params['page'] = 1 unless params.has_key?('page')
      params['per_page'] = 25 unless params.has_key?('per_page')

      uri = URI(url_return_all_applications)
      uri.query = URI.encode_www_form(params)

      begin
        res = Net::HTTP.get(uri)
      rescue => exception
        puts exception.to_s
      else
        JSON.parse(res) unless res.nil?
      end
    end

    def get_attribute_json(id)
      params = {}
      params['access_token'] = EXPA.client.get_updated_token
      params['person_id'] = id

      uri = URI(url_view_application_attributes(id))
      uri.query = URI.encode_www_form(params)

      begin
        res = Net::HTTP.get(uri)
      rescue => exception
        puts exception.to_s
      else
        JSON.parse(res) unless res.nil?
      end
    end

    def url_return_all_applications
      $url_api + 'applications'
    end

    def url_view_application_attributes(id)
      url_return_all_applications + '/' + id.to_s
    end
  end
end