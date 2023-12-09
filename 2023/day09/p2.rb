require "minitest/autorun"

class Day09P2
  def initialize(path)
    @input_path = path
    parse_input
  end

  def parse_input
    @histories = File.readlines(@input_path)
      .map { |l| l.split(" ").map { |n| n.to_i } }
  end

  def solve
    parse_input

    nums = @histories.map do |history|
      projections = [history]

      until projections.last.all? { |n| n == 0 }
        differences = projections.last.each_cons(2).map { |a, b| b - a }
        projections << differences
      end

      projections.reverse!.each_with_index do |projection, idx|
        next if projections[idx + 1].nil?

        curr_first_val = projection.first
        next_first_val = projections[idx + 1].first
        new_next_first_val = + next_first_val - curr_first_val

        projections[idx + 1].unshift(new_next_first_val)
      end

      projections.last.first
    end

    p nums
    p nums.reduce(:+)
    nums.reduce(:+)
  end
end

class Day09P2Test < Minitest::Test
  def test_solve_example
    result = Day09P2.new("sample.txt").solve
    assert_equal(result, 2)
  end
end
