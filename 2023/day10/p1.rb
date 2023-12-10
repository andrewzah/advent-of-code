require "minitest/autorun"

# | -> N + S
# - -> E + W
# L -> N + E
# J -> N + W
# 7 -> S + W
# F -> S + E
# . -> no pipe
# S -> starting position
class Day10P1
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

  # [1,1] -> [[0,1], [1,0], [2,1], [1,2]
  def get_neighbors(row, col)
    neighbors = {north: [row - 1, col], west: [row, col - 1],
                 south: [row + 1, col], east: [row, col + 1]}

    neighbors.filter! do |k, (n_row, n_col)|
      n_row >= 0 && n_row < @grid.length && n_col >= 0 && n_col < @grid[0].length
    end
    neighbors.filter! do |k, (row, col)|
      @mappings[k].include?(@grid[row][col])
    end

    neighbors.map { |k, v| v }
  end

  def solve
    max = 0
    seen = {}
    queue = [@start_loc]

    until queue.empty?
      curr_node, curr_steps = queue.pop

      max = [max, curr_steps].max
      seen[curr_node] = 1

      neighbors = get_neighbors(curr_node[0], curr_node[1])
      neighbors.each do |neighbor|
        queue.unshift([neighbor, curr_steps + 1]) unless seen.has_key?(neighbor)
      end
    end

    max
  end
end

class Day10P1Test < Minitest::Test
  def test_solve_example_1
    result = Day10P1.new("sample_1_p1.txt").solve
    assert_equal(result, 4)
  end

  def test_solve_example_2
    result = Day10P1.new("sample_2_p1.txt").solve
    assert_equal(result, 8)
  end

  def test_solve_input
    result = Day10P1.new("input.txt").solve
    assert_equal(result, 6812)
  end
end
