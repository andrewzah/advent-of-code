require "minitest/autorun"

class Day07P2
  def parse_input
    @type_values = {five_of: 7, four_of: 6, full_house: 5, three_of: 4,
              two_pair: 3, one_pair: 2, high_card: 1}
    @char_values = {"J" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8,
                    "9" => 9, "T" => 10, "Q" => 11, "K" => 12, "A" => 13}

    l = File.readlines(@input_path)
      .map{|s| s.strip.split(" ")}
      .map{|a, b| { hand: a, bet: b.to_i}}
      .map{|h| h[:type] = get_type(h[:hand]); h }
      .sort_by{|h|
        rank = @type_values[h[:type]]
        chars = h[:hand].chars.map{|c| @char_values[c]}

        [rank, chars]
      }
      .each_with_index.map{|hash, idx|
        (idx+1) * hash[:bet]
      }
      .reduce(:+)

    l
  end

  def get_type(hand)
    hash = hand.chars.reduce(Hash.new(0)){|hash, char| hash[char] += 1; hash}
    if hash.key?('J')
      return :five_of if hash.length == 1

      num_j = hash.delete('J')
      most = hash.max_by{|k, v| v}
      hash[most[0]] += num_j
    end
    hash_vals = hash.map{|k, v| v}

    return :five_of if hash.length == 1
    return :four_of if hash_vals.include?(4)
    return :full_house if hash_vals.include?(3) && hash.length == 2
    return :three_of if hash_vals.include?(3) && hash.length == 3
    return :two_pair if hash_vals.include?(2) && hash.length == 3
    return :one_pair if hash_vals.include?(2) && hash.length == 4
    return :high_card if hash.length == 5

    return :high_card
  end

  def solve
    parse_input
  end

  def initialize(path)
    @input_path = path
  end
end

class Day07P2Test < Minitest::Test
  def test_solve_example
    result = Day07P2.new("input.txt").solve
    assert_equal(result, 5905)
  end
end
