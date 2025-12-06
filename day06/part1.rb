#!/usr/bin/env ruby
# https://adventofcode.com/2025/day/6

input = File.read('day06/input').lines.map(&:strip)
# input = File.read('day06/example').lines.map(&:strip)

problems = input.map(&:split).transpose
solutions = problems.map do |problem|
  op = problem.pop
  eval problem.join(op)
end

puts solutions.sum
