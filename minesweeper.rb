require_relative 'board'

class MinesweeperGame
  GRID_ROWS = 9
  GRID_COLUMNS = 9

  def initialize
    @board = Board.new(GRID_ROWS, GRID_COLUMNS)
  end

  def run
    @board.populate_bombs
    # take turns until you hit a bomb (lose) or only bombs remain unrevealed (win)
    until @board.hit_bomb || won?
      render
      play_turn
    end
    if @board.hit_bomb
      puts "You lost :("
    else
      puts "You won!"
    end
    reveal_board
    render
  end

  # shows the whole board when the game is over
  def reveal_board
    @board.grid.each do |row|
      row.each { |tile| tile.reveal }
    end
  end

  # prints a visualization of the board with labeled row and column indices
  def render
    labels = (0...GRID_COLUMNS).map { |n| n.to_s.center(4) }.join("")
    puts "    #{labels}"
    puts "    #{ "-" * (@board.grid[0].length * 4) }"
    rows = @board.grid.map.with_index do |row, i|
      "#{i.to_s.rjust(2)} |#{row.map(&:to_s).join("|")}|\n   #{ "-" * (@board.grid[0].length * 4) }"

    end
    puts rows.join("\n")
  end

  def play_turn
    pos, is_flagged = nil, false
    until pos
      puts "What position do you want to reveal? (e.g. 3,4)"
      response = @board.parse_pos(gets) # makes sure input is in the right format
      if response
        pos, is_flagged = response
      else
        puts "Wrong input format"
      end
    end

    # if you want to flag the tile instead of reveal its value
    if is_flagged
      @board[pos].flag
    else
      @board.reveal(pos)
      @board.hit_bomb = true if @board[pos].has_bomb?
    end
  end

  # if the only unrevealed tiles left are bombs, then you've won
  def won?
    @board.grid.each do |row|
      row.each { |tile| return false unless tile.revealed? || tile.has_bomb? }
    end
    true
  end

end

if __FILE__ == $PROGRAM_NAME
  g = MinesweeperGame.new
  g.run
end
