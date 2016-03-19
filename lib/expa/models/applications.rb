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

    def url_return_all_applications
      $url_api + 'applications'
    end

  end
end