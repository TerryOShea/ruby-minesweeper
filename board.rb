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
      @bombs << [(0..8).to_a.sample, (0..8).to_a.sample]
      @bombs.uniq!
    end

    @bombs.each { |pos| self[pos] = Tile.new("B") }
    bomb_neighbors
  end

  def bomb_neighbors
    @bombs.each do |bomb|
      row, col = bomb
      (-1...2).each do |i|
        increment_val(row-1, col+i)
        increment_val(row+1, col+i)
      end
      increment_val(row, col-1)
      increment_val(row, col+1)
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
    self[pos].reveal if valid_pos?(pos)
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

  def won?
    @grid.each do |row|
      row.each { |tile| return false unless tile.revealed? || tile.has_bomb? }
    end
    true
  end

end
