require "minitest/autorun"

class Day11P2
  attr_accessor :grid

  def initialize(path)
    @input_path = path
    parse_input

    @galaxies = find_galaxies(@grid)
    @empty_columns = get_empty_columns(@grid)
    @empty_rows = get_empty_rows(@grid)
  end

  def parse_input
    @grid = File.readlines(@input_path).map { |l| l.strip.chars }
  end

  def solve(expand_by)
    pairs = @galaxies.keys.combination(2).to_a

    distances = pairs.map do |a, b|
      distance(@galaxies[a], @galaxies[b], expand_by)
    end

    distances.reduce(:+)
  end

  private

  def distance(start, target, expand_by)
    from_x = [start[0], target[0]].min
    to_x = [start[0], target[0]].max
    between_x = @empty_rows
      .filter { |col| (from_x..to_x).to_a.include?(col) }

    from_y = [start[1], target[1]].min
    to_y = [start[1], target[1]].max
    between_y = @empty_columns
      .filter { |row| (from_y..to_y).to_a.include?(row) }

    dist = manhattan(start, target)
    expand_x = (between_x.length * (expand_by - 1))
    expand_y = (between_y.length * (expand_by - 1))

    (dist + expand_x + expand_y)
  end

  def manhattan(a, b)
    a.zip(b).map { |v1, v2| (v1 - v2).abs }.sum
  end

  def get_empty_rows(grid)
    grid.each_with_index.map do |line, idx|
      if line.all? { |c| c == "." }
        idx
      end
    end.compact
  end

  def get_empty_columns(grid)
    length = grid[0].length
    cols = []

    (0..length - 1).each do |j|
      chars = grid.map { |line| line[j] }

      if chars.all? { |c| c == "." }
        cols << j
      end
    end

    cols
  end

  def find_galaxies(grid)
    i = 1
    galaxies = {}

    grid.each_with_index do |line, r_idx|
      line.each_with_index do |char, c_idx|
        if char == "#"
          galaxies[i] = [r_idx, c_idx]
          i += 1
        end
      end
    end

    galaxies
  end
end

class Day11P2Test < Minitest::Test
  def test_solve_sample_10
    result = Day11P2.new("sample.txt").solve(10)
    assert_equal(1030, result)
  end

  def test_solve_sample_100
    result = Day11P2.new("sample.txt").solve(100)
    assert_equal(8410, result)
  end

  def test_solve_input
    result = Day11P2.new("input.txt").solve(1_000_000)
    assert_equal(483844716556, result)
  end
end
