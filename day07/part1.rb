#!/usr/bin/env ruby
# https://adventofcode.com/2025/day/7

require_relative '../lib/grid'

input = File.read('day07/input').lines.map(&:strip)
# input = File.read('day07/example').lines.map(&:strip)

grid = Grid.new

input.reverse.each_with_index do |line, y|
  line.chars.each_with_index do |char, x|
    grid[x, y] = char
  end
end

count = 0

grid.each_row do |y, row|
  row.each do |x, value|
    case value
    when ?|
      if grid[x, y-1] == ?^
        grid[x-1, y-1] = ?|
        grid[x+1, y-1] = ?|
        count += 1
      else
        grid[x, y-1] = ?|
      end
    when ?S
      grid[x, y-1] = ?|
    end
  end
end

puts count
