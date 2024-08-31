require 'minitest/autorun'

def fizzbuzz(n, print_associations)
  puts 'hello world'

  for i in 1..n    
    print_entity = ''

    print_associations.each do |value|
      print_entity = "#{print_entity}#{value[1]}" if i % value[0] == 0
    end

    print_entity = "#{i}" if print_entity == ''

    puts print_entity
  end
  return 0
end

def is_palindrome(str)
  l_index = 0
  r_index = str.length - 1

  while l_index < r_index
    return false if str[l_index].upcase != str[r_index].upcase
    l_index += 1
    r_index -= 1
  end

  return true
end


class TestMethods < Minitest::Test
  def test_fizzbuzz
    assert_equal 0, fizzbuzz(200, [[7, 'Monkey'], [5, 'Fizz'], [3, 'Buzz']])
    assert_equal false, is_palindrome('hi')
    assert_equal true, is_palindrome('racecar')
  end
end