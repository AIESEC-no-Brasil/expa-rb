require 'test_helper'

class ApplicationsTest < Minitest::Test
  def setup
    if EXPA.client.nil?
      @expa = EXPA.setup()
      @expa.auth(ENV['ROBOZINHO_EMAIL'],ENV['ROBOZINHO_PASSWORD'])
    else
      @expa = EXPA.client
    end
  end

  def test_list_by_param
    params = {}

    result = EXPA::Applications.list_by_param
    assert(result, 'No result')

    items_to_retrieve = 5
    params['per_page'] = items_to_retrieve
    result = EXPA::Applications.list_by_param(params)
    assert(result, 'No result')
    assert(result.is_a?(Array), 'Wrong type returned')
    assert(result.first.is_a?(Application), 'Wrong type returned')
    assert(result.count == items_to_retrieve, ' No result or wrong result. Expected ' + items_to_retrieve.to_s + ' and got ' + result.count.to_s)

    items_to_retrieve = 50
    params['per_page'] = items_to_retrieve
    result = EXPA::Applications.list_by_param(params)
    assert(result, 'No result')
    assert(result.is_a?(Array), 'Wrong type returned')
    assert(result[0].is_a?(Application), 'Wront type returned')
    assert(result.count == items_to_retrieve, ' No result or wrong result. Expected ' + items_to_retrieve.to_s + ' and got ' + result.count.to_s)
  end
end