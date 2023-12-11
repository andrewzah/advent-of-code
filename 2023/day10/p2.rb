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
    @left = {}
    @right = {}

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
    p "curr char: #{@grid[row][col]}, at [#{row}, #{col}]"
    neighbors = {
      east: [row, col + 1],
      west: [row, col - 1],
      north: [row - 1, col],
      south: [row + 1, col],
    }

    neighbors.filter! do |k, (n_row, n_col)|
      n_row >= 0 && n_row < @grid.length && n_col >= 0 && n_col < @grid[0].length
    end
    # s -> e
    # e -> n
    # n -> w
    # w -> s
    neighbors, dots = neighbors.partition do |_, (n_row, n_col)|
      "S|-LJ7F".chars.include?(@grid[n_row][n_col])
    end
    p neighbors
    p dots

    dots.each do |k, (n_row, n_col)|
      directions.each do |direction|
        p "dir: #{direction}"
        p "p.k: #{k}"
        p = "^"

        next if direction == :start
        next if @left.has_key?([n_row, n_col])
        case direction
        when :south
          @left[[n_row, n_col]] = 1 if k == :east
          @right[[n_row, n_col]] = 1 if k == :west
        when :east
          @left[[n_row, n_col]] = 1 if k == :north
          @right[[n_row, n_col]] = 1 if k == :south
        when :north
          @left[[n_row, n_col]] = 1 if k == :west
          @right[[n_row, n_col]] = 1 if k == :east
        when :west
          @left[[n_row, n_col]] = 1 if k == :south
          @right[[n_row, n_col]] = 1 if k == :north
        end
      end
    end

    neighbors.filter! do |k, (n_row, n_col)|
      @mappings[@grid[row][col]].include?(k)
    end

    neighbors.map { |k, v| [v, k] }
  end

  # 1. iter until start is found
  # 2. keep track of direction
  # 3. all non-valid-path chars on the LEFT are interior, assuming
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
        elsif @left.has_key?([r_idx, c_idx])
          print "L"
        elsif @right.has_key?([r_idx, c_idx])
          print "R"
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

    p @left.length
    p @right.length
    @left.length
  end
end

class Day10P2Test < Minitest::Test
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

  #def test_solve_input
  #  result = Day10P2.new("input.txt").solve
  #  assert_equal(result, -1)
  #end
end
