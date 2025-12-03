#!/usr/bin/env ruby
# https://adventofcode.com/2025/day/3

input = File.read('day03/input').lines.map(&:strip)
# input = File.read('day03/example').lines.map(&:strip)

foo = input.map do |line|
  digits = line.to_i.digits.reverse
  first = digits[0..-2].max
  second = digits[(digits.index(first)+1)..-1].max
  "#{first}#{second}".to_i
end

puts foo.sum
