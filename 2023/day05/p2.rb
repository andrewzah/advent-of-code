require 'minitest/autorun'

class Day05P2
  def parse_input
    lines = File.read(@input_path).split("\n\n")
    seeds = lines[0].split(": ").last.split(" ").map(&:to_i)
    @seed_ranges = seeds.each_slice(2).map do |start, range|
      {
        lower_bound: start,
        upper_bound: start + range - 1
      }
    end

    @mappings = lines[1..].map { |line|
      elems = line.split("\n")
      name = elems[0].split(" ").first

      entries = []
      elems[1..].each do |str|
        dest, src, range = str.split(" ").map(&:to_i)
        if dest > src
          op = :negative
          offset = dest - src
        else
          op = :positive
          offset = src - dest
        end

        entries << {
          src_lower: src,
          src_upper: src + range - 1,
          dest_lower: dest,
          dest_upper: dest + range - 1,
          offset: offset,
          op: op
        }
      end

      [name, entries]
    }.to_h
  end

  def solve
    parse_input

    lowest_location = -1
    4294967296.times do |location|
      break if lowest_location != -1

      humidity = get_mapping_reverse(location, @mappings["humidity-to-location"])
      temperature = get_mapping_reverse(humidity, @mappings["temperature-to-humidity"])
      light = get_mapping_reverse(temperature, @mappings["light-to-temperature"])
      water = get_mapping_reverse(light, @mappings["water-to-light"])
      fertilizer = get_mapping_reverse(water, @mappings["fertilizer-to-water"])
      soil = get_mapping_reverse(fertilizer, @mappings["soil-to-fertilizer"])
      seed = get_mapping_reverse(soil, @mappings["seed-to-soil"])

      @seed_ranges.each do |hash|
        lower = hash[:lower_bound]
        upper = hash[:upper_bound]

        if (lower..upper).cover?(seed)
          lowest_location = location
          break
        end
      end
    end

    lowest_location
  end

  def get_mapping_reverse(num, arr)
    arr.each do |hash|
      lower = hash[:dest_lower]
      upper = hash[:dest_upper]

      if (lower..upper).cover?(num)
        newnum = (hash[:op] == :positive) ? num + hash[:offset] : num - hash[:offset]
        return newnum
      end
    end

    num
  end

  def initialize(path)
    @input_path = path
  end
end

class Day05P2Test < Minitest::Test
  def test_solve_example
    result = Day05P2.new("sample.txt").solve
    assert_equal(result, 46)
  end
end
