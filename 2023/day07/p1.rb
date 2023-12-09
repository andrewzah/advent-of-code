require "minitest/autorun"

# 5 of a kind     [AAAAA]
# 4 of a kind     [AAAAB]
# full house      [AAABB]
# three of a kind [AAABC]
# two pair        [AABBC]
# one pair        [AABCD]
# high card       [ABCDE]
# sort by first card in hand
class Day07P1
  def parse_input
    @type_values = {five_of: 7, four_of: 6, full_house: 5, three_of: 4,
              two_pair: 3, one_pair: 2, high_card: 1}
    @char_values = {"2" => 1, "3" => 2, "4" => 3, "5" => 4, "6" => 5, "7" => 6, "8" => 7,
                    "9" => 8, "T" => 9, "J" => 10, "Q" => 11, "K" => 12, "A" => 13}

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
    hash_vals = hash.map{|k, v| v}

    return :five_of if hash.length == 1
    return :four_of if hash_vals.include?(4)
    return :full_house if hash_vals.include?(3) && hash.length == 2
    return :three_of if hash_vals.include?(3) && hash.length == 3
    return :two_pair if hash_vals.include?(2) && hash.length == 3
    return :one_pair if hash_vals.include?(2) && hash.length == 4
    return :high_card if hash.length == 5
  end

  def solve
    parse_input
  end

  def initialize(path)
    @input_path = path
  end
end

class Day07P1Test < Minitest::Test
  def test_solve_example
    result = Day07P1.new("input.txt").solve
    assert_equal(result, 6440)
  end
end
