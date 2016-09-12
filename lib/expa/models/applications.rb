require_relative 'opportunities'

class Application
  # Data that comes at the lists from people
  attr_accessor :id
  attr_accessor :url
  attr_accessor :status
  attr_accessor :current_status
  attr_accessor :an_signed_at
  attr_accessor :favourite
  attr_accessor :person
  attr_accessor :opportunity
  attr_accessor :permissions
  attr_accessor :created_at
  attr_accessor :updated_at

  # Data that comes at the get attributes

  attr_accessor :interviewed
  attr_accessor :paid
  attr_accessor :paid_at
  attr_accessor :paid_by
  attr_accessor :experience_start_date
  attr_accessor :experience_end_date
  attr_accessor :matched_or_rejected_at
  attr_accessor :matchability
  attr_accessor :meta
  attr_accessor :date_matched
  attr_accessor :date_approved
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
    self.paid_at = Time.parse(json['paid_at']) unless json['paid_at'].nil? #novo
    self.paid_by = json['paid_by'] unless json['paid_by'].nil? #novo
    self.person = Person.new(json['person']) unless json['person'].nil?
    #self.branch = json['branch'] unless json['branch'].nil? #novo
    self.an_signed_at = Time.parse(json['an_signed_at']) unless json['an_signed_at'].nil? #novo
    self.experience_start_date = Time.parse(json['experience_start_date']) unless json['experience_start_date'].nil? #novo
    self.experience_end_date = Time.parse(json['experience_end_date']) unless json['experience_end_date'].nil? #novo
    self.matched_or_rejected_at = Time.parse(json['matched_or_rejected_at']) unless json['matched_or_rejected_at'].nil? #novo
    unless json['meta'].nil?
      self.meta = json['meta']
      self.date_matched = Time.parse(self.meta['date_matched']) unless self.meta['date_matched'].nil? #novo
      self.date_approved = Time.parse(self.meta['date_approved']) unless self.meta['date_approved'].nil? #novo
      self.date_realized = Time.parse(self.meta['date_realized']) unless self.meta['date_realized'].nil? #novo
      self.date_completed = Time.parse(self.meta['date_completed']) unless self.meta['date_completed'].nil? #novo
      self.date_ldm_completed = Time.parse(self.meta['date_ldm_completed']) unless self.meta['date_ldm_completed'].nil? #novo
    end

    #self.meta
  end
end

class Analytics
  
end

module EXPA::Applications
  class << self
    def paging(params)
      res = list_json(params)
      unless res.nil?
        data = res['paging']

        {
          :total_items => data['total_items'],
          :total_pages => data['total_pages']
        }
      end
    end

    #EXPA only accepts the following filters['status']: 'matched' (accepted), 'accepted' (in progress), 'approved' (approved), 'realized' (realized), 'completed' (completed), 'withdrawn' (withdrawn), 'rejected' (rejected), 'declined' (declined)
    def list_by_param(params = {})
      applications = []

      res = list_json(params)
      unless res.nil?
        data = res['data']

        data.each do |item|
          applications << Application.new(item)
        end

        applications
      end
    end

    def list_all
      applications = []
      params = {'per_page' => 500}
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

    def analisa(params = {})
      params['access_token'] = EXPA.client.get_updated_token
      params['start_date'] = Date.today unless params.has_key?('start_date')
      params['end_date'] = Date.today unless params.has_key?('end_date')
      params['programmes[]'] = 1
      params['basic[home_office_id]'] = 1606 unless params.has_key?('basic[home_office_id]')
      params['basic[type]'] = 'person'

      uri = URI(url_return_analytics)
      uri.query = URI.encode_www_form(params)
      puts uri
      puts uri.query

      result = {}
      res = force_get_response(uri)
      result['oGCDP'] = res['analytics']['children']['buckets'].map{ |lc| [lc['key'],{apd:lc['total_approvals']['doc_count'],re:lc['total_realized']['doc_count']}]}.to_h

      params['programmes[]'] = 1
      params['basic[type]'] = 'opportunity'
      uri = URI(url_return_analytics)
      uri.query = URI.encode_www_form(params)
      puts uri
      puts uri.query
      result['iGCDP'] = force_get_response(uri)['analytics']['children']['buckets'].map{ |lc| [lc['key'],{apd:lc['total_approvals']['doc_count'],re:lc['total_realized']['doc_count']}]}.to_h

      params['programmes[]'] = 2
      params['basic[type]'] = 'person'
      uri = URI(url_return_analytics)
      uri.query = URI.encode_www_form(params)
      puts uri
      puts uri.query
      result['oGIP'] = force_get_response(uri)['analytics']['children']['buckets'].map{ |lc| [lc['key'],{apd:lc['total_approvals']['doc_count'],re:lc['total_realized']['doc_count']}]}.to_h

      params['programmes[]'] = 2
      params['basic[type]'] = 'opportunity'
      uri = URI(url_return_analytics)
      uri.query = URI.encode_www_form(params)
      puts uri
      puts uri.query
      result['iGIP'] = force_get_response(uri)['analytics']['children']['buckets'].map{ |lc| [lc['key'],{apd:lc['total_approvals']['doc_count'],re:lc['total_realized']['doc_count']}]}.to_h

      result
    end

    private

    def list_json(params = {})
      params['access_token'] = EXPA.client.get_updated_token
      params['page'] = 1 unless params.has_key?('page')
      params['per_page'] = 25 unless params.has_key?('per_page')

      uri = URI(url_return_all_applications)
      uri.query = URI.encode_www_form(params)

      force_get_response(uri)
    end

    def get_attribute_json(id)
      params = {}
      params['access_token'] = EXPA.client.get_updated_token
      params['person_id'] = id

      uri = URI(url_view_application_attributes(id))
      uri.query = URI.encode_www_form(params)

      force_get_response(uri)
    end

    def url_return_all_applications
      $url_api + 'applications'
    end

    def url_return_analytics
      url_return_all_applications + '/analyze.json'
    end

    def url_view_application_attributes(id)
      url_return_all_applications + '/' + id.to_s
    end

    def force_get_response(uri)
      #puts 'Applictions: ' + uri.to_s
      i = 0
      while i <= 60
        begin
          res = Net::HTTP.get(uri)
          puts res
          res = JSON.parse(res) unless res.nil?
          i = 1000
        rescue => exception
          puts exception.to_s
          raise TokenException, 'Token has expired', caller if i == 60
          sleep(i)
        end
      end
      res
    end
  end
end
class TokenException < RuntimeError
  attr :okToRetry
  def initialize(okToRetry)
    @okToRetry = okToRetry
  end
end