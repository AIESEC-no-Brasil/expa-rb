require_relative 'teams'

class CurrentPosition

  attr_accessor :id
  attr_accessor :position_name
  attr_accessor :position_short_name
  attr_accessor :url
  attr_accessor :start_date
  attr_accessor :end_date
  attr_accessor :job_description
  attr_accessor :team

  def initialize(json)
    self.id = json['id'] unless json['id'].nil?
    self.position_name = json['position_name'] unless json['position_name'].nil?
    self.position_short_name = json['position_short_name'] unless json['position_short_name'].nil?
    self.url = json['url'] unless json['url'].nil?
    self.start_date = Time.parse(json['start_date']) unless json['start_date'].nil?
    self.end_date = Time.parse(json['end_date']) unless json['end_date'].nil?
    self.job_description = json['job_description'] unless json['job_description'].nil?
    self.team = Team.new(json['team']) unless json['team'].nil?
  end

end