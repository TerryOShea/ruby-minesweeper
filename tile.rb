require 'colorize'

class Tile

  COLORS = {
    "B" => :light_red,
    1 => :blue,
    2 => :green
  }

  attr_accessor :value

  def initialize(value)
    @value = value
    @hidden = true
    @flagged = false
  end

  def reveal
    @hidden = false
  end

  def revealed?
    !@hidden
  end

  def has_bomb?
    @value == "B"
  end

  def flag
    @flagged = !@flagged if @hidden
  end

  def flagged?
    @flagged
  end

  def to_s
    return " \u2691 ".encode('utf-8').colorize(:magenta) if @flagged
    return " * " if @hidden
    return "   " if @value == 0
    if COLORS.key?(@value)
      " #{@value} ".colorize(COLORS[@value])
    else
      " #{@value} ".colorize(:cyan)
    end
  end

end
