require_relative 'board'

class MinesweeperGame
  GRID_ROWS = 9
  GRID_COLUMNS = 9

  def initialize
    @board = Board.new(GRID_ROWS, GRID_COLUMNS)
  end

  def run
    @board.populate_bombs
    render
    until @board.hit_bomb || @board.won?
      play_turn
      render
    end
    if @board.hit_bomb
      puts "You lost :("
    else
      puts "You won!"
    end
  end

  def render
    puts "   #{(0...GRID_COLUMNS).to_a.join(" ")}"

    rows = @board.grid.map.with_index do |row, i|
      "#{i} |#{row.map(&:to_s).join("|")}|"
    end
    puts rows.join("\n")
  end

  def play_turn
    pos, is_flagged = nil, false
    until pos
      puts "What position do you want to reveal? (e.g. 3,4)"
      response = @board.parse_pos(gets)
      if response
        pos, is_flagged = response
      else
        puts "Wrong input format"
      end
    end

    if is_flagged
      @board[pos].flag
    else
      @board[pos].reveal
      @board.hit_bomb = true if @board[pos].has_bomb?
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  g = MinesweeperGame.new
  g.run
end
