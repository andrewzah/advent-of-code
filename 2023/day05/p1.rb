require 'minitest/autorun'

class Day05P1
  def parse_input
    lines = File.read(@input_path).split("\n\n")
    @seeds = lines[0].split(": ").last.split(" ").map(&:to_i)

    @mappings = lines[1..].map { |line|
      elems = line.split("\n")
      name = elems[0].split(" ").first

      entries = []
      elems[1..].each do |str|
        dest, src, range = str.split(" ").map(&:to_i)
        if src > dest
          op = :negative
          offset = src - dest
        else
          op = :positive
          offset = dest - src
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

    @seeds.map do |seed|
      soil = get_mapping(seed, @mappings["seed-to-soil"])
      fertilizer = get_mapping(soil, @mappings["soil-to-fertilizer"])
      water = get_mapping(fertilizer, @mappings["fertilizer-to-water"])
      light = get_mapping(water, @mappings["water-to-light"])
      temperature = get_mapping(light, @mappings["light-to-temperature"])
      humidity = get_mapping(temperature, @mappings["temperature-to-humidity"])
      location = get_mapping(humidity, @mappings["humidity-to-location"])

      {soil: soil, fertilizer: fertilizer, water: water,
      light: light, temperature: temperature,
      humidity: humidity, location: location}
    end.min_by{ |h| h[:location] }[:location]
  end

  def initialize(path)
    @input_path = path
  end

  def get_mapping(num, arr)
    arr.each do |hash|
      lower = hash[:src_lower]
      upper = hash[:src_upper]

      if (lower..upper).cover?(num)
        newnum = (hash[:op] == :positive) ? num + hash[:offset] : num - hash[:offset]
        return newnum
      end
    end

    num
  end
end

class Day05P1Test < Minitest::Test
  def test_solve_example
    result = Day05P1.new("sample.txt").solve
    assert_equal(result, 35)
  end
end
