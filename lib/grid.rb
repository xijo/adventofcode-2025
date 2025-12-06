# {
#   2: { 0: -, 1: - }
#   1:
#   0:
# }

require 'pastel'

class Grid
  include Enumerable
  attr_accessor :marked

  def initialize(default = nil)
    @mem = Hash.new({})
    @default = default
    @marked = {}
  end

  def [](x, y)
    if @default
      @mem[y][x] ||= @default.dup
    else
      @mem[y][x]
    end
  end
  alias_method :get, :[]

  def []=(x, y, value)
    row = @mem[y].dup
    row[x] = value
    @mem[y] = row
  end
  alias_method :set, :[]=

  # Find all position pairs with the given value
  def positions(value)
    result = []
    @mem.each do |y, row|
      row.each do |x, col|
        result << [x, y] if get(x, y) == value
      end
    end
    result
  end

  def each(&block)
    y_range.each do |y|
      x_range.each do |x|
        block.call(x, y, @mem[y][x])
      end
    end
  end

  def increment(x, y, amount = 1)
    @mem[y][x] += amount
  end

  def mark(x, y, color = [:on_yellow])
    @marked[[x, y]] = color
  end

  def clear_marks
    @marked = {}
  end

  def clear_values
    y_range.each do |y|
      x_range.each do |x|
        self[x, y] = nil
      end
    end
  end

  def marked?(x, y, value = nil)
    if value
      @marked[[x, y]] == value
    else
      @marked.keys.include?([x, y])
    end
  end

  def y_range
    max = [@mem.keys.max, 0].compact.max
    min = [@mem.keys.min, 0].compact.min
    min..max
  end

  def x_range
    max = [@mem.values.map { |col| col.keys.max }.max, 0].compact.max
    min = [@mem.values.map { |col| col.keys.min }.min, 0].compact.min
    min..max
  end

  # Gives horizontal and vertial adjacent positions
  def adjacent(x, y, within_bounds: true)
    result = [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]]
    if within_bounds # exclude out-of-bounds positions
      result.select { |x, y| x_range.include?(x) && y_range.include?(y) }
    else
      result
    end
  end

  def each_adjacent(x, y, &block)
    adjacent(x, y).each do |ad|
      yield((ad + [get(*ad)]))
    end
  end

  def adjacent_values(x, y)
    adjacent(x, y).map { |x, y| get(x, y) }
  end

  # like adjacent, but includes diagonal positions as well
  def surrounding(x, y)
    result = [
      [x - 1, y],
      [x + 1, y],
      [x, y - 1],
      [x, y + 1],
      [x + 1, y + 1],
      [x - 1, y + 1],
      [x + 1, y - 1],
      [x - 1, y - 1],
    ]
    result.select { |x,y| x_range.include?(x) && y_range.include?(y) }
  end

  def surrounding_values(x, y)
    surrounding(x, y).map { |x, y| get(x, y) }
  end

  def each_surrounding(x, y, &block)
    surrounding(x, y).each do |ad|
      yield((ad + [get(*ad)]))
    end
  end

  def contains?(x, y)
    x_range.include?(x) && y_range.include?(y)
  end

  def inspect_compact
    max_y = [@mem.keys.max, 0].compact.max + 2
    min_y = [@mem.keys.min, 0].compact.min - 1
    max_x = [@mem.values.map { |col| col.keys.max }.max, 0].compact.max + 2
    min_x = [@mem.values.map { |col| col.keys.min }.min, 0].compact.min - 1
    max_length = 1
    axis = 8

    table = (min_y...max_y).to_a.map do |y|
      row = (min_x...max_x).to_a.map do |x|
        # Pastel.new.decorate(@mem[y][x].to_s.rjust(max_length), *Array(@marked[[x, y]]))     # get without dup-setting to not expand the grid

        # @mem[y][x].to_s.rjust(max_length) #.color(@marked[[x, y]] || :color255)


        if marked?(x, y)
          Pastel.new.decorate(@mem[y][x].to_s.rjust(max_length), :black, :on_yellow)
        else
          @mem[y][x].to_s.rjust(max_length)
        end
      end.join
      # "#{y.to_s.rjust(axis)} #{row}"
    end.reverse.join(?\n)
    table
  end

  def inspect
    max_y = [@mem.keys.max, 0].compact.max + 2
    min_y = [@mem.keys.min, 0].compact.min - 1
    max_x = [@mem.values.map { |col| col.keys.max }.max, 0].compact.max + 2
    min_x = [@mem.values.map { |col| col.keys.min }.min, 0].compact.min - 1
    max_length = [@mem.values.map { |col| col.values.map { |v| v.inspect.length }.max }.max, 1].compact.max
    # max_length = 4
    axis = 8

    table = (min_y...max_y).to_a.map do |y|
      row = (min_x...max_x).to_a.map do |x|
        # Pastel.new.decorate(@mem[y][x].to_s.rjust(max_length), *Array(@marked[[x, y]]))     # get without dup-setting to not expand the grid

        # @mem[y][x].to_s.rjust(max_length) #.color(@marked[[x, y]] || :color255)


        if marked?(x, y)
          Pastel.new.decorate(@mem[y][x].to_s.rjust(max_length), :black, :on_yellow)
        else
          @mem[y][x].to_s.rjust(max_length)
        end
      end.join(' ')
      "#{y.to_s.rjust(axis)} #{row}"
    end.reverse.join(?\n)
    table + "\n".ljust(axis + 2) + (min_x...max_x).map { |i| i.to_s.rjust(max_length) }.join(' ') + "\n"
  end

  def draw_path(path, &block)
    path.points.each do |(x, y)|
      set(x, y, yield(get(x, y)))
    end
  end

  def draw(from, to, reverse: false, &block)
    x_range = Range.new(*[from.first, to.first].sort)
    y_range = Range.new(*[from.last, to.last].sort)
    x_range.each do |x|
      y_range.each do |y|
        set(x, y, yield(get(x, y)))
      end
    end
  end
end
