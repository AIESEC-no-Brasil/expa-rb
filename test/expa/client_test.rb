require 'test_helper'

class ClientTest < Minitest::Test
  def setup
    @expa = EXPA.setup()
  end

  def test_auth
    @expa.auth('robozinhomcbazi@gmail.com','mcmosaico4ever123')
    assert(@expa.get_token, 'Test is not working or robozinho user has lost access to EXPA')
    assert(@expa.get_expiration_time, 'Test is not working or robozinho user has lost access to EXPA')
    assert(@expa.get_max_age, 'Test is not working or robozinho user has lost access to EXPA')
  end


end
