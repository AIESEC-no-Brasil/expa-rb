require 'test_helper'

class PeoplesTest < Minitest::Test
  def setup
    @expa = EXPA.setup()
    @expa.auth('robozinhomcbazi@gmail.com','mcmosaico4ever123')
  end

  def test_list_by_param
    result = EXPA::Peoples.list_by_param
    assert(result, 'No result')
  end

  def test_list

  end

  def test_total_item
    total = EXPA::Peoples.total_items
    assert(total.is_a?(Integer), 'Total of item is not a number or is not working')
  end
end