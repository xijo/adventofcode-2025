#!/usr/bin/env ruby
# https://adventofcode.com/2025/day/4

require_relative '../lib/grid'
require 'byebug'

input = File.read('day04/input').lines.map(&:strip)
# input = File.read('day04/example').lines.map(&:strip)
grid = Grid.new

input.reverse.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    grid[x, y] = char
  end
end

moveable = 0
grid.each do |x, y, value|
  next unless value == ?@
  if grid.surrounding_values(x, y).count(?@) < 4
    moveable += 1
    grid.mark(x, y)
  end
end

puts moveable
