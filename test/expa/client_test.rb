require 'test_helper'



class ClientTest < Minitest::Test
  def setup
    @expa = EXPA.setup()
    @expa.auth('robozinhomcbazi@gmail.com','mcmosaico4ever123')
  end

  def test_auth
    expa = @expa
    assert(expa.get_token, 'Test is not working or robozinho user has lost access to EXPA')
    assert(expa.get_expiration_time, 'Test is not working or robozinho user has lost access to EXPA')
    assert(expa.get_max_age, 'Test is not working or robozinho user has lost access to EXPA')
  end

  def test_updated_token
    expa = @expa
    assert(expa.get_token, 'Test is not working or robozinho user has lost access to EXPA')
    assert(expa.get_updated_token, 'Test is not working or robozinho user has lost access to EXPA')
    assert(expa.get_updated_token == expa.get_token, 'Test is not working or robozinho user has lost access to EXPA')
  end

end
