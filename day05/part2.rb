#!/usr/bin/env ruby
# https://adventofcode.com/2025/day/5

require 'byebug'

input = File.read('day05/input')
# input = File.read('day05/example')

ranges, _ = input.split("\n\n")
ranges = ranges.lines.map { eval _1.sub(?-, '..') }.sort_by(&:min)

class Range
  def merge(other)
    raise ArgumentError, "Ranges do not overlap" unless overlaps?(other)
    Range.new *(other.minmax + minmax).flatten.sort.minmax
  end

  def overlaps?(other)
    member?(other.min) || member?(other.max) || other.member?(self.min) || other.member?(self.max) || (other.min == self.max + 1) || (other.max == self.min - 1)
  end
end

merged = []

until ranges.empty? do
  range = ranges.shift
  if ranges.first && range.overlaps?(ranges.first)
    new_range = range.merge(ranges.shift)
    ranges.unshift(new_range)
  else
    merged << range
  end
end

puts merged.map(&:size).sum
