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
    puts "\n\n"
    @input_path = path
    @mappings = {
      "|" => [:north, :south],
      "-" => [:east, :west],
      "L" => [:north, :east],
      "J" => [:north, :west],
      "7" => [:south, :west],
      "F" => [:south, :east],
      "S" => [:north, :south, :east, :west],
      "." => [],
      "I" => [],
      "O" => [],
    }
    @glyphs = {
      "|" => "│",
      "-" => "─",
      "L" => "└",
      "J" => "┘",
      "7" => "┐",
      "F" => "┌",
    }

    parse_input
  end

  def parse_input
    @grid = File.readlines(@input_path).map { |l| l.strip.chars }
    @start_loc = nil
    @grid.each_with_index do |row, r_idx|
      break if !@start_loc.nil?

      row.each_with_index do |char, c_idx|
        if char == "S"
          @start_loc = [[r_idx, c_idx], :nil]
          break
        end
      end
    end
  end

  def get_neighbors(directions, row, col)
    neighbors = {
      east: [row, col + 1],
      west: [row, col - 1],
      north: [row - 1, col],
      south: [row + 1, col],
    }

    neighbors.filter! do |k, (n_row, n_col)|
      n_row >= 0 && n_row < @grid.length && n_col >= 0 && n_col < @grid[0].length
    end
    neighbors.filter! do |_, (n_row, n_col)|
      "S|-LJ7F".chars.include?(@grid[n_row][n_col])
    end
    neighbors.filter! do |k, (n_row, n_col)|
      @mappings[@grid[row][col]].include?(k)
    end

    neighbors.map { |k, v| [v, k] }
  end

  def shoelace(arr)
    nums = []

    arr.each_with_index do |(left, right), idx|
      next_nums = nil

      if idx == arr.length - 1
        next_nums = arr[0]
      else
        next_nums = arr[idx+1]
      end

      next_left = next_nums[0]
      next_right = next_nums[1]

      nums[idx] = (left * next_right) - (right * next_left)
    end

    nums.reduce(:+) * 0.5
  end

  def picks_theorem(area, loop_length)
    area - 0.5 * loop_length + 1
  end

  def solve
    seen = {}
    queue = [@start_loc]
    last_directions = [:start, :start]

    until queue.empty?
      curr_node, curr_direction = queue.pop
      last_directions = [last_directions[1], curr_direction]
      seen[curr_node] = 1

      neighbors = get_neighbors(last_directions, curr_node[0], curr_node[1])
      neighbors.filter!{|loc, dir| !seen.has_key?(loc)}
      break if neighbors.length == 0

      neighbors.each do |neighbor|
        queue.append(neighbor) unless seen.has_key?(neighbor)
      end
    end

    @grid.each_with_index do |row, r_idx|
      row.each_with_index do |char, c_idx|
        if [r_idx, c_idx] == @start_loc[0]
          print "S"
        elsif seen.has_key?([r_idx, c_idx])
          print @glyphs[char]
        else
          if char == "I"
            print "I"
          else
            print "."
          end
        end
      end

      print "\n"
    end

    area = shoelace(seen.map{|k, v| k})
    picks = picks_theorem(area.abs, seen.length)

    puts "loop length: #{seen.length}"
    puts "area: #{area}"
    puts "picks: #{picks}"

    picks
  end
end

class Day10P2Test < Minitest::Test
  def test_shoelace
    coords = [
      [4, 4],
      [0, 1],
      [-2, 5],
      [-6, 0],
      [-1, -4],
      [5, -2]
    ]
    result = Day10P2.new("sample_1_p2.txt").shoelace(coords)
    assert_equal(55, result)
  end


  #def test_solve_example_1
  #  result = Day10P2.new("sample_1_p2.txt").solve
  #  assert_equal(4, result)
  #end

  #def test_solve_example_2
  #  result = Day10P2.new("sample_2_p2.txt").solve
  #  assert_equal(4, result)
  #end

  def test_solve_example_3
    result = Day10P2.new("sample_3_p2.txt").solve
    assert_equal(8, result)
  end

  def test_solve_example_4
    result = Day10P2.new("sample_4_p2.txt").solve
    assert_equal(result, 10)
  end

  def test_solve_input
    result = Day10P2.new("input.txt").solve
    assert_equal(result, 529)
  end
end
