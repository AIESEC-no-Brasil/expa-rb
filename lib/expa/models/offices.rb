class Office
  attr_accessor :id
  attr_accessor :parent_id
  attr_accessor :name
  attr_accessor :full_name
  attr_accessor :url


  def initialize(json)
    self.id = json['id'].to_i unless json['id'].nil?
    self.parent_id = json['parent_id'].to_i unless json['id'].nil?
    self.name = json['name'] unless json['name'].nil?
    self.full_name = json['full_name'] unless json['full_name'].nil?
    self.url = URI(json['url']) unless json['url'].nil?
  end
end

module EXPA::Offices
  class << self

  end
end