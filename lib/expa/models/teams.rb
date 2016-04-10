class Team

  attr_accessor :id
  attr_accessor :title
  attr_accessor :team_type
  attr_accessor :url
  attr_accessor :office

  def initialize(json)
    self.id = json['id'] unless json['id'].nil?
    self.title = json['title'] unless json['title'].nil?
    self.team_type = json['team_type'] unless json['team_type'].nil?
    self.url = json['url'] unless json['url'].nil?
    self.office = Office.new(json['office']) unless json['office'].nil?
  end

end
module Teams
  class << self

  end
end