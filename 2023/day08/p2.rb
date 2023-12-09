require "minitest/autorun"

class Day08P2
  def parse_input
    lines = File.readlines(@input_path)
    @directions = lines[0].strip.chars
    @locations = lines[2..-1]
      .map{|s| s.gsub(/[(),]/, "").split(" ") }
      .reduce(Hash.new){|h, a| h[a[0]] = {left: a[2], right: a[3]}; h}
  end

  def solve
    parse_input
    locations = @locations.map{|k, v| [k, 0]}.filter{|loc, _| loc.chars.last == "A"}

    total = 0
    i = 0
    loop do
      if locations.map{|loc, _| loc}.all?{|loc| loc.chars.last == "Z"}
        total = locations.map{|_, total| total}.reduce(1, :lcm)
        break
      end

      direction = @directions[i % @directions.length]

      locations.map! do |loc, total|
        next([loc, total]) if loc.chars.last == "Z"
        nodes = @locations[loc]
        newloc = direction == "L" ? nodes[:left] : nodes[:right]
        [newloc, total+1]
      end

      i += 1
    end

    total
  end

  def initialize(path)
    @input_path = path
  end
end

class Day08P2Test < Minitest::Test
  def test_solve_example
    result = Day08P2.new("sample_p2.txt").solve
    assert_equal(result, 6)
  end
end
