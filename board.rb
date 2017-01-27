require 'set'
require_relative 'tile'

class Board

  attr_accessor :grid

  def initialize(row_num, col_num, mines_num)
    @row_num = row_num
    @col_num = col_num
    @grid = Array.new(@row_num) { Array.new(@col_num) { Tile.new(0) } }
    @mines_num = mines_num
  end

  # adds mines to the board
  def populate_board
    mines = Set.new

    until mines.length == @mines_num
      row = (0...@row_num).to_a.sample
      col = (0...@col_num).to_a.sample
      mines.add([row, col])
    end

    # updates each neighbor of a mine
    mines.each do |mine|
      self[mine] = Tile.new("mine")
      neighbors(mine).each { |neighbor| increment_val(neighbor) }
    end
  end

  # the value of a tile is based on how many mines it abuts
  def increment_val(pos)
    self[pos].value += 1 if valid_pos?(pos) && !self[pos].has_mine?
  end

  # returns (up to 8) neighbor indices for a given pos
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

  # checks whether a position is actually on the board
  def valid_pos?(pos)
    return false unless ((pos[0] >= 0) && (pos[0] < @row_num))
    (pos[1] >= 0) && (pos[1] < @col_num)
  end

  def [](pos)
    row, col = pos
    @grid[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @grid[row][col] = value
  end

  # reveals tile; if it's not near mines, recursively reveals its neighbors
  def reveal(pos)
    return if self[pos].revealed? || self[pos].flagged?
    puts "is flagged; still here" if self[pos].flagged?
    self[pos].reveal
    neighbors(pos).each { |neighbor| reveal(neighbor) } if self[pos].value == 0
  end

  def flag(pos)
    self[pos].flag if valid_pos?(pos)
  end

end
