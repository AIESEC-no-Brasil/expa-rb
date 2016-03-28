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

  def test_find_attributes_by_id
    params = {}

    items_to_retrieve = 1
    params['per_page'] = items_to_retrieve
    application_to_compare = EXPA::Applications.list_by_param(params).first

    application_real = EXPA::Applications.get_attributes(application_to_compare.id)
    assert(application_real, 'No result')
    assert(application_real.is_a?(Application), 'Wront type returned')
    assert(application_real.id == application_to_compare.id, 'It is not the same register')
  end

  def test_total_item
    total = EXPA::Applications.total_items
    assert(total.is_a?(Integer), 'Total of item is not a number or is not working')
  end
end