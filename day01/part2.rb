#!/usr/bin/env ruby
# https://adventofcode.com/2025/day/1

# input = File.read('day01/example').lines.map(&:strip)
input = File.read('day01/input').lines.map(&:strip)

dial = (0..99).to_a.rotate(50)
pw = 0

input.each do |line|
  spin = line.sub(/[RL]/, ?R => '', ?L => ?-).to_i

  spin.abs.times do
    dial.rotate! spin.negative? ? 1 : -1
    pw += 1 if dial.first == 0
  end
end

puts pw
