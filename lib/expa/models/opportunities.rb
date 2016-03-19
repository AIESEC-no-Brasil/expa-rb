require_relative 'programmes'
require_relative 'peoples'
require_relative 'offices'

class Opportunity
  attr_accessor :id
  attr_accessor :title
  attr_accessor :url
  attr_accessor :status
  attr_accessor :location
  attr_accessor :programmes
  attr_accessor :managers_ids
  attr_accessor :office
  attr_accessor :application_count
  attr_accessor :earliest_start_date
  attr_accessor :latest_end_date
  attr_accessor :applications_close_date
  attr_accessor :profile_photo_url

  def initialize(json)
    self.id = json['id'] unless json['id'].nil?
    self.title = json['title'] unless json['title'].nil?
    self.url = URI(json['url']) unless json['url'].nil?
    self.status = json['status'] unless json['status'].nil?
    self.location = json['location'] unless json['location'].nil?
    programmes_temp = []
    json['programmes'].each do |programme|
      programmes_temp << Programme.new(programme)
    end
    self.programmes = programmes_temp
    managers = []
    json['managers'].each do |manager|
      managers << manager['id']
    end
    self.managers_ids = managers unless json['managers'].nil?
    self.office = Office.new(json['office']) unless json['office'].nil?
    self.application_count = json['applications_count'] unless json['applications_count'].nil?
    self.earliest_start_date = Time.parse(json['earliest_start_date']) unless json['earliest_start_date'].nil?
    self.latest_end_date = Time.parse(json['latest_end_date']) unless json['latest_end_date'].nil?
    self.applications_close_date = Time.parse(json['applications_close_date']) unless json['applications_close_date'].nil?
    self.profile_photo_url = URI(json['profile_photo_url']) unless json['profile_photo_url'].nil?
  end
end

module EXPA::Opportunities
  class << self

  end
end