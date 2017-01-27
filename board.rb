require_relative 'tile'

class Board
  NUM_BOMBS = 10

  attr_accessor :grid, :hit_bomb
  attr_reader :bombs

  def initialize(rows, cols)
    @grid = Array.new(rows) { Array.new(cols) { Tile.new(0) } }
    @hit_bomb = false
  end

  def populate_bombs
    @bombs = []

    until @bombs.length == NUM_BOMBS
      @bombs << [(0...@grid.length).to_a.sample, (0...@grid[0].length).to_a.sample]
      @bombs.uniq!
    end

    @bombs.each { |pos| self[pos] = Tile.new("B") }
    bomb_neighbors
  end

  def bomb_neighbors
    @bombs.each do |bomb|
      neighbors(bomb).each { |neighbor| increment_val(*neighbor) }
    end
  end

  def increment_val(row, col)
    if row >= 0 && row < @grid.length && col >= 0 && col < @grid[0].length
      tile = @grid[row][col]
      tile.value += 1 unless tile.has_bomb?
    end
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  def reveal(pos)
    return if self[pos].revealed? || self[pos].flagged?
    self[pos].reveal if valid_pos?(pos)
    # puts self[pos].value
    if self[pos].value == 0
      neighbors(pos).each { |neighbor| reveal(neighbor) unless @bombs.include?(neighbor) }
    end
  end

  def neighbors(pos)
    row, col = pos
    neighbors = []

    (-1...2).each do |i|
      neighbors << [row-1, col+i] if valid_pos?([row-1, col+i])
      neighbors << [row+1, col+i] if valid_pos?([row+1, col+i])
    end
    neighbors << [row, col-1] if valid_pos?([row, col-1])
    neighbors << [row, col+1] if valid_pos?([row, col+1])

    neighbors
  end

  def valid_pos?(pos)
    return false unless ((pos[0] >= 0) && (pos[0] < @grid.length))
    (pos[1] >= 0) && (pos[1] < @grid[0].length)
  end

  def parse_pos(string)
    match_obj = /^(f?)\s?(\d+)[, ]+(\d+)$/.match(string)
    return false unless match_obj
    return false unless valid_pos?([match_obj[2], match_obj[3]].map(&:to_i))
    [[match_obj[2], match_obj[3]].map(&:to_i), match_obj[1] == "f"]
  end

  def flag(pos)
    self[pos].flag if valid_pos?(pos)
  end

end
