#!/usr/bin/env ruby
# https://adventofcode.com/2025/day/2

input = File.read('day02/input').lines.map(&:strip)
# input = File.read('day02/example').lines.map(&:strip)

input = input.first.split(?,).map { eval _1.sub(?-, '..') }

invalid = []
input.each do |range|
  range.each do |n|
    len = n.digits.size
    next unless len % 2 == 0
    if n.to_s[0, len / 2] == n.to_s[len / 2, len]
      invalid << n
    end
  end
end
puts invalid.sum
