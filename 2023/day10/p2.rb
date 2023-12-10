require "minitest/autorun"

# | -> N + S
# - -> E + W
# L -> N + E
# J -> N + W
# 7 -> S + W
# F -> S + E
# . -> no pipe
# S -> starting position
class Day10P2
  def initialize(path)
    @input_path = path
    parse_input

    @mappings = {
      north: ["|", "7", "F"],
      south: ["|", "L", "J"],
      west: ["-", "L", "F"],
      east: ["-", "J", "7"]
    }
  end

  def parse_input
    @grid = File.readlines(@input_path).map { |l| l.strip.chars }
    @start_loc = nil
    @grid.each_with_index do |row, r_idx|
      break if !@start_loc.nil?

      row.each_with_index do |char, c_idx|
        if char == "S"
          @start_loc = [[r_idx, c_idx], 0]
          break
        end
      end
    end
  end

  def solve
    0
  end
end

class Day10P2Test < Minitest::Test
  def test_solve_example_1
    result = Day10P2.new("sample_1_p2.txt").solve
    assert_equal(result, 4)
  end

  def test_solve_example_2
    result = Day10P2.new("sample_2_p2.txt").solve
    assert_equal(result, 4)
  end

  def test_solve_example_3
    result = Day10P2.new("sample_3_p2.txt").solve
    assert_equal(result, 8)
  end

  def test_solve_example_4
    result = Day10P2.new("sample_4_p2.txt").solve
    assert_equal(result, 10)
  end

  def test_solve_input
    result = Day10P2.new("input.txt").solve
    assert_equal(result, -1)
  end
end
