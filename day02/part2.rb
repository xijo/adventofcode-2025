#!/usr/bin/env ruby
# https://adventofcode.com/2025/day/2

input = File.read('day02/input').lines.map(&:strip)
# input = File.read('day02/example').lines.map(&:strip)

# Steal #in_groups_of from Rails
class Array
  def in_groups_of(number, fill_with = nil, &block)
    if number.to_i <= 0
      raise ArgumentError,
        "Group size must be a positive integer, was #{number.inspect}"
    end

    if fill_with == false
      collection = self
    else
      # size % number gives how many extra we have;
      # subtracting from number gives how many to add;
      # modulo number ensures we don't add group of just fill.
      padding = (number - size % number) % number
      collection = dup.concat(Array.new(padding, fill_with))
    end

    if block_given?
      collection.each_slice(number, &block)
    else
      collection.each_slice(number).to_a
    end
  end
end

input = input.first.split(?,).map { eval _1.sub(?-, '..') }

invalid = []

input.each do |range|
  range.each do |n|
    (1..(n.digits.size/2)).each do |offset|
      if n.digits.in_groups_of(offset).uniq.size == 1
        # puts n
        invalid << n
        break
      end
    end
  end
end
puts invalid.sum
