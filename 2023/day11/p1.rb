require "minitest/autorun"

class Day11P1
  attr_accessor :grid

  def initialize(path)
    @input_path = path
    @galaxies = {}

    parse_input
    fix_grid
    find_galaxies
  end

  def parse_input
    @grid = File.readlines(@input_path).map { |l| l.strip.chars }
  end

  def fix_grid
    fix_grid_horizontal
    fix_grid_vertical
  end

  def find_galaxies
    i = 1
    @grid.each_with_index do |line, r_idx|
      line.each_with_index do |char, c_idx|
        if char == "#"
          @galaxies[i] = [r_idx, c_idx]
          i += 1
        end
      end
    end
  end

  def solve
    pairs = @galaxies.keys.combination(2).to_a

    distances = pairs.map do |a, b|
      manhattan(@galaxies[a], @galaxies[b])
    end

    distances.reduce(:+)
  end

  private

  def manhattan(a, b)
    a.zip(b).map { |v1, v2| (v1 - v2).abs }.sum
  end

  def fix_grid_horizontal
    length = @grid.length
    i = 0

    while i != length - 1
      line = @grid[i]
      if line.all? { |c| c == "." }
        @grid.insert(i, line.clone)
        i += 2
        next
      end

      i += 1
      length = @grid.length
    end
  end

  def fix_grid_vertical
    length = @grid[0].length
    j = 0

    while j != length - 1
      chars = @grid.map { |line| line[j] }
      if chars.all? { |c| c == "." }
        @grid.map! { |line| line.insert(j, ".") }

        length = @grid[0].length
        j += 2
        next
      end

      j += 1
      length = @grid[0].length
    end
  end
end

class Day11P1Test < Minitest::Test
  def test_solve_example_1
    result = Day11P1.new("sample.txt").solve
    assert_equal(result, 374)
  end

  def test_solve_input
    result = Day11P1.new("input.txt").solve
    assert_equal(result, 9684228)
  end
end
