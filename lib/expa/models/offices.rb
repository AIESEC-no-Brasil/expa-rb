class Office
  def initialize(json)
    @id = json['id'].to_i
    @name = json['name']
    @full_name = json['full_name']
    @url = URI(json['url'])
  end
end

module EXPA::Offices
  class << self

  end
end