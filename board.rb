require_relative 'tile'

class Board
  NUM_BOMBS = 10
  GRID_ROWS = 9
  GRID_COLUMNS = 9

  attr_accessor :grid
  attr_reader :bombs

  def initialize(grid = nil)
    @grid = Array.new(9) { Array.new(9) { Tile.new(0) } }
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

  def render
    puts "   #{(0...GRID_COLUMNS).to_a.join(" ")}"

    rows = @grid.map.with_index do |row, i|
      "#{i} |#{row.map(&:to_s).join("|")}|"
    end
    puts rows.join("\n")
  end

  def reveal(pos)
    self[pos].reveal if valid_pos?(pos)
  end

  def valid_pos?(pos)
    return false unless ((pos[0] >= 0) && (pos[0] < GRID_ROWS))
    (pos[1] >= 0) && (pos[0] < GRID_COLUMNS)
  end

  def flag(pos)
    self[pos].flag if valid_pos?(pos)
  end

  def unflag(pos)
    self[pos].unflag if valid_pos?(pos)
  end

  def run
    until @hit_bomb || won?
      play_turn
      render
    end
    if @hit_bomb
      puts "You lost :("
    else
      puts "You won!"
    end
  end

  def won?
    @grid.each do |row|
      row.each { |tile| return false unless tile.revealed? || tile.has_bomb? }
    end
    true
  end

  def play_turn
    pos = nil
    until pos && valid_pos?(pos)
      puts "What position do you want to reveal? (e.g. 3,4)"
      begin
        pos = parse_pos(gets)
      rescue
        puts "Invalid position entered (did you use a comma?)"
        puts ""

        pos = nil
      end
    end
    self[pos].reveal

    @hit_bomb = true if self[pos].has_bomb?
  end

  def parse_pos(string)
    string.split(",").map(&:to_i)
  end

end

if __FILE__ == $PROGRAM_NAME
  b = Board.new
  b.populate_bombs
  b.render
  p b.bombs
  b.run
end
