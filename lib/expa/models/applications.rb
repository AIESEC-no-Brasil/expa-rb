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
    self.permissions = json['permissions'] unless json['permissions'].nil? #TODO struct
    self.created_at = Time.parse(json['created_at']) unless json['created_at'].nil?
    self.updated_at = Time.parse(json['updated_at']) unless json['updated_at'].nil?
    self.opportunity = json['opportunity'] unless json['opportunity'].nil? #TODO strut
  end
end

module EXPA::Applications
  class << self

  end
end