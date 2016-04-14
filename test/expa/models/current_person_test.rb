require 'test_helper'

class CurrentPersonTest < Minitest::Test
  def setup
    if EXPA.client.nil?
      @expa = EXPA.setup()
      @expa.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])
    else
      @expa = EXPA.client
    end
  end

  def test_get_person
    result = EXPA::CurrentPerson.get_current_person
    assert(result, 'No result')
    assert(result.email = 'robozinhomcbazi@gmail.com', 'ops')
    assert(result.is_a?(Person), 'Wront type returned')
  end
end