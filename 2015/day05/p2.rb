require 'minitest/autorun'

class Day05P2
  def parse_input
    @lines = File.readlines(@path)
      .map{|l| l.strip }
  end

  def solve
    parse_input

    @lines.filter{|line| is_nice(line) }.length
  end

  def is_nice(string)
    doubles = string.scan(/(?<o>[a-zA-Z]{2}).*(\k<o>)/).empty? == false
    match = string.match(/(?<total>(?<l>\w+)\w(\k<l>))/)
    letter_repeat = !match.nil? && !match[:total].nil?

    doubles && letter_repeat
  end

  def initialize(path)
    @path = path
  end
end

class Day05P2Test < Minitest::Test
  def test_solve
    result = Day05P2.new("sample_p2.txt").solve
    assert_equal(result, 2)
  end
end
