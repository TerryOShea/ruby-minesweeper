require_relative 'tile'

class Board
  def initialize(grid = nil)
    @grid = Array.new(9) { Array.new(9) }
  end

  def populate_bombs
    pos = [(0..8).to_a.sample, (0..8).to_a.sample]
    @grid[pos] = Tile.new("B")
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

end
