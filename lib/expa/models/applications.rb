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
  attr_accessor :paid
  attr_accessor :an_signed_at
  attr_accessor :experience_start_date
  attr_accessor :experience_end_date
  attr_accessor :matched_or_rejected_at
  attr_accessor :date_matched
  attr_accessor :date_realized
  attr_accessor :date_completed
  attr_accessor :date_ldm_completed

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
    self.paid = json['paid'] unless json['paid'].nil? #novo
    #self.paid_at
    #self.paid_by
    self.person = Person.new(json['person']) unless json['person'].nil?
    #self.branch # TODO Struct
    self.an_signed_at = Time.parse(json['an_signed_at']) unless json['an_signed_at'].nil? #novo
    self.experience_start_date = Time.parse(json['experience_start_date']) unless json['experience_start_date'].nil? #novo
    self.experience_end_date = Time.parse(json['experience_end_date']) unless json['experience_end_date'].nil? #novo
    self.matched_or_rejected_at = Time.parse(json['matched_or_rejected_at']) unless json['matched_or_rejected_at'].nil? #novo
    unless json['meta'].nil?
      meta = json['meta']
      self.date_matched = Time.parse(meta['date_matched']) unless meta['date_matched'].nil? #novo
      self.date_realized = Time.parse(meta['date_realized']) unless meta['date_realized'].nil? #novo
      self.date_completed = Time.parse(meta['date_completed']) unless meta['date_completed'].nil? #novo
      self.date_ldm_completed = Time.parse(meta['date_ldm_completed']) unless meta['date_ldm_completed'].nil? #novo
    end

    #self.meta
  end
end

module EXPA::Applications
  class << self
    #EXPA only accepts the following filters['status']: 'matched' (accepted), 'accepted' (in progress), 'approved' (approved), 'realized' (realized), 'completed' (completed), 'withdrawn' (withdrawn), 'rejected' (rejected), 'declined' (declined)
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