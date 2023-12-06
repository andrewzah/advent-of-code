require "minitest/autorun"

class Day06P1
  def parse_input
    @time, @distance = File
      .readlines(@input_path)
      .map { |line| line.split(": ").last.strip }
      .map { |l| l.split(/[ ]+/).join.to_i }
  end

  def solve
    parse_input

    0.upto(@time)
      .map { |n| [n, @time - n] }
      .map { |a, b| 1 if a * b > @distance }
      .compact
      .length
  end

  def initialize(path)
    @input_path = path
  end
end

class Day06P1Test < Minitest::Test
  def test_solve_example
    result = Day06P1.new("sample.txt").solve
    assert_equal(result, 71503)
  end
end
