require_relative 'board'
require 'colorize'

class MinesweeperGame

  LEVEL_REF = {
    :beginner => { :size => [8, 8], :mines => 10 },
    :intermediate => { :size => [16, 16], :mines => 40 },
    :expert => { :size => [16, 30], :mines => 99 }
  }

  def initialize(level)
    @row_num, @col_num = LEVEL_REF[level][:size]
    mines_num = LEVEL_REF[level][:mines]
    @board = Board.new(@row_num, @col_num, mines_num)
    @hit_mine = false
  end

  def run
    @board.populate_board

    # take turns until you hit a mine (lose) or only mines remain unrevealed (win)
    until @hit_mine || won?
      render
      play_turn
    end

    if @hit_mine
      puts "You lost :(".colorize(:light_red)
    else
      puts "You won!".colorize(:green)
    end

    reveal_board
    render
  end

  # reveals all tiles when the game is over
  def reveal_board
    @board.grid.each do |row|
      row.each { |tile| tile.reveal }
    end
  end

  # prints a visualization of the board with labeled row and column indices
  def render
    labels = (0...@col_num).map { |n| n.to_s.center(4) }.join("")
    puts "    #{labels}"
    puts "    #{ "-" * (@col_num * 4 - 1) }"

    rows = @board.grid.map.with_index do |row, i|
      "#{i.to_s.rjust(2)} |#{row.map(&:to_s).join("|")}|\n" +
      "    #{ "-" * (@col_num * 4 - 1) }"
    end
    puts rows.join("\n")
  end

  def play_turn
    pos, will_flag = nil, false
    until pos
      puts "What position do you want to reveal or flag? (e.g. 3,4 or f 3,4)"
      response = parse_pos(gets) # makes sure input is in the right format
      if response
        pos, will_flag = response
      else
        puts "Wrong input format"
      end
    end

    # if you want to flag the tile instead of reveal its value
    if will_flag
      @board[pos].flag
    elsif !@board[pos].flagged?
      @board.reveal(pos)
      if @board[pos].has_mine?
        @board[pos].value = "hit"
        @hit_mine = true
      end
    end
  end

  # if the only unrevealed tiles left are mines, then you've won
  def won?
    @board.grid.each do |row|
      row.each { |tile| return false unless tile.revealed? || tile.has_mine? }
    end
    true
  end

  # validates user input: optional "f" (flag), then two in-range position numbers
  def parse_pos(string)
    match_obj = /^(f?)\s?(\d+)[, ]+(\d+)$/.match(string)
    return false unless match_obj
    return false unless @board.valid_pos?([match_obj[2], match_obj[3]].map(&:to_i))
    [[match_obj[2], match_obj[3]].map(&:to_i), match_obj[1] == "f"]
  end

end

if __FILE__ == $PROGRAM_NAME
  g = MinesweeperGame.new(:beginner) # or :intermediate, or :expert
  g.run
end
