require 'test_helper'

class PeoplesTest < Minitest::Test
  def setup
    @expa = EXPA.setup()
    @expa.auth('robozinhomcbazi@gmail.com','mcmosaico4ever123')
  end

  def test_list_by_param
    params = {}

    result = EXPA::Peoples.list_by_param
    assert(result, 'No result')

    items_to_retrieve = 5
    params['per_page'] = items_to_retrieve
    result = EXPA::Peoples.list_by_param(params)
    assert(result, 'No result')
    assert(result.count == items_to_retrieve, ' No result or wrong result. Expected ' + items_to_retrieve.to_s + ' and got ' + result.count.to_s)

    items_to_retrieve = 50
    params['per_page'] = items_to_retrieve
    result = EXPA::Peoples.list_by_param(params)
    assert(result, 'No result')
    assert(result.count == items_to_retrieve, ' No result or wrong result. Expected ' + items_to_retrieve.to_s + ' and got ' + result.count.to_s)
  end

  def test_total_item
    total = EXPA::Peoples.total_items
    assert(total.is_a?(Integer), 'Total of item is not a number or is not working')
  end
end