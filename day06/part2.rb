#!/usr/bin/env ruby
# https://adventofcode.com/2025/day/6

require 'byebug'
input = File.read('day06/input').lines
# input = File.read('day06/example').lines

input.each { puts _1.inspect }

ops = input[4].scan(/(\S\s+)/).flatten

problems = ops.map do |op|
  new_problem = input[0..3]
    .map { _1.slice!(0, op.len) }
    .map { _1[0..-2].gsub(' ', '0').chars }
    .transpose
    .map(&:join)
    .map { (tz = _1[/([0]+\z)/]) ? _1.chars.rotate(-tz.size).join : _1 }
    .map { _1.to_i }
    .join(op.strip)
end

puts problems.map { eval _1 }.sum
