require 'minitest/autorun'

def test_function(msg)
  puts msg
  return 1
end

class TestMethods < Minitest::Test
  def test_run_test
    assert_equal 1, test_function('hello world')
  end
end