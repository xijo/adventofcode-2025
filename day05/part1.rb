#!/usr/bin/env ruby
# https://adventofcode.com/2025/day/5

input = File.read('day05/input')
# input = File.read('day05/example')

fresh_ranges, ingredients = input.split("\n\n")
fresh_ranges = fresh_ranges.lines.map { eval _1.sub(?-, '..') }
ingredients = ingredients.lines.map { _1.strip.to_i }
fresh = ingredients.select { |i| fresh_ranges.any? { _1.include?(i) } }
puts fresh.size
