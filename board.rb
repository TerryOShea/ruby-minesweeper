require_relative 'tile'

class Board
  NUM_BOMBS = 10
  GRID_ROWS = 9
  GRID_COLUMNS = 9

  attr_accessor :grid

  def initialize(grid = nil)
    @grid = Array.new(9) { Array.new(9) { Tile.new(0) } }
  end

  def populate_bombs
    bombs = []

    until bombs.length == NUM_BOMBS
      bombs << [(0..8).to_a.sample, (0..8).to_a.sample]
      bombs.uniq!
    end

    bombs.each { |pos| self[pos] = Tile.new("B") }
    bomb_neighbors(bombs)
  end

  def bomb_neighbors(bomb_positions)
    bomb_positions.each do |bomb|
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
    if row >= 0 && row < GRID_ROWS && col >= 0 && col < GRID_COLUMNS
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

end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.populate_bombs
  puts b.grid.map {|row| row.map(&:to_s).join("")}.join("\n")
end
