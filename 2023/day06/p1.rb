require "minitest/autorun"

class Day06P1
  def parse_input
    lines = File
      .readlines(@input_path)
      .map { |line| line.split(": ").last.strip }
      .map { |l| l.split(/[ ]+/) }

    @races = lines[0].zip(lines[1]).map do |time, distance|
      {
        time: time.to_i,
        distance: distance.to_i
      }
    end
  end

  def solve
    parse_input

    @races.map! do |race|
      combos = (0..race[:time]).to_a.product((0..race[:time]).to_a)
        .filter { |a, b| a + b == race[:time] }

      wins = combos.map { |a, b| a * b }.filter { |n| n > race[:distance] }
      wins.length
    end

    @races.reduce(:*)
  end

  def initialize(path)
    @input_path = path
  end
end

class Day06P1Test < Minitest::Test
  def test_solve_example
    result = Day06P1.new("sample.txt").solve
    assert_equal(result, 288)
  end
end
