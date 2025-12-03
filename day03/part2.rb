#!/usr/bin/env ruby
# https://adventofcode.com/2025/day/3

input = File.read('day03/input').lines.map(&:strip)
# input = File.read('day03/example').lines.map(&:strip)

def find_highest_possibility(digits, found = [])
  return found if found.size == 12

  remaining = 12 - found.size
  found << digits[0..-remaining].max
  find_highest_possibility(digits[(digits.index(found.last)+1)..-1], found)
end

joltages = input.map do |line|
  digits = line.to_i.digits.reverse
  find_highest_possibility(digits).join.to_i
end

puts joltages.sum
