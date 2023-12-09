require 'digest'
require 'minitest/autorun'

# 5 of a kind     [AAAAA]
# 4 of a kind     [AAAAB]
# full house      [AAABB]
# three of a kind [AAABC]
# two pair        [AABBC]
# one pair        [AABCD]
# high card       [ABCDE]
# sort by first card in hand
class Day04
  def self.solve_p1(input)
    0.upto(2**32-1) do |i|
      return i if Digest::MD5.hexdigest("#{input}#{i}")[0..4] == "00000"
    end
  end

  def self.solve_p2(input)
    0.upto(2**32-1) do |i|
      return i if Digest::MD5.hexdigest("#{input}#{i}")[0..5] == "000000"
    end
  end
end

class Day04P1Test < Minitest::Test
  def test_solve_p1
    result = Day04.solve_p1('iwrupvqb')
    assert_equal(result, 346386)
  end

  def test_solve_p2
    result = Day04.solve_p2('iwrupvqb')
    assert_equal(result, 9958218)
  end
end
