require 'minitest/autorun'

class Day05
  def parse_input
    @lines = File.readlines(@path)
  end

  def solve
    parse_input

    @lines.filter{|line| is_nice(line) }.length
  end

  def is_nice(string)
    disallowed = /ab|cd|pq|xy/
    return false if string.scan(disallowed).length > 0

    aeiou3 = string.scan(/[aeiou]+.*[aeiou]+.*[aeiou]/).length > 0
    double = string.scan(/(?<char>[a-zA-Z])(\k<char>)/).length > 0

    aeiou3 && double
  end

  def initialize(path)
    @path = path
  end
end

class Day05P1Test < Minitest::Test
  def test_solve
    result = Day05.new("sample_p1.txt").solve
    assert_equal(result, 2)
  end
end
