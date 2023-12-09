require "minitest/autorun"

class Day09P1
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

        curr_last_val = projection.last
        next_last_val = projections[idx + 1].last
        new_next_last_val = next_last_val + curr_last_val

        projections[idx + 1].push(new_next_last_val)
      end

      projections.last.last
    end

    nums.reduce(:+)
  end
end

class Day09P1Test < Minitest::Test
  def test_solve_example
    result = Day09P1.new("sample.txt").solve
    assert_equal(result, 114)
  end
end
