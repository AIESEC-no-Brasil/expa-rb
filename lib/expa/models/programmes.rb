class Programme
  attr_accessor :id
  attr_accessor :short_name

  def initialize(json)
    self.id = json['id'] unless json['id'].nil?
    self.short_name = json['short_name'] unless json['short_name'].nil?
  end
end

module EXPA::Programmes
  class << self

  end
end