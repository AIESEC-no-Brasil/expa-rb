class Office
  attr_accessor :id
  attr_accessor :name
  attr_accessor :full_name
  attr_accessor :url


  def initialize(json)
    self.id = json['id'].to_i unless json['id'].nil?
    self.name = json['name'] unless json['name'].nil?
    self.full_name = json['full_name'] unless json['full_name'].nil?
    self.url = URI(json['url']) unless json['url'].nil?
  end
end

module EXPA::Offices
  class << self
    def list_single_office(xp_id)
      single_office_list_json({}, xp_id)
    end
  end


  private

  def single_office_list_json(params = {}, xp_id)
    params['access_token'] = EXPA.client.get_updated_token
    params['committee_id'] = xp_id

    uri = URI(url_return_committee(xp_id))
    uri.query = URI.encode_www_form(params)

    force_get_response(uri)
  end

  def url_return_committee(xp_id)
    $url_api + "committees/#{xp_id}"
  end

  def force_get_response(uri)
    i = 0
    while i < 50
      begin
        res = Net::HTTP.get(uri)
        res = JSON.parse(res) unless res.nil?
        i = 50
      rescue => exception
        puts exception.to_s
        sleep(i)
      end
    end
    res
  end
end
