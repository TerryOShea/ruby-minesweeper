require 'colorize'

class Tile

  COLORS_REF = {
    1 => :blue,
    2 => :green,
    3 => :red,
    4 => :cyan,
  }

  attr_accessor :value

  def initialize(value)
    @value = value
    @hidden = true
    @flagged = false
  end

  def reveal
    @hidden = false
    @flagged = false
  end

  def revealed?
    !@hidden
  end

  def has_mine?
    @value == "mine" || @value == "hit"
  end

  def flag
    @flagged = !@flagged if @hidden
  end

  def flagged?
    @flagged
  end

  def to_s
    return " \u2691 ".encode('utf-8').colorize(:magenta) if @flagged
    return " \u2620 ".encode('utf-8').colorize(:light_red) if @value == "hit" # a triggered mine
    return " * " if @hidden
    return " \u2609 ".encode('utf-8').colorize(:light_red) if @value == "mine"
    return "   " if @value == 0

    if COLORS_REF.key?(@value)
      " #{@value} ".colorize(COLORS_REF[@value])
    else
      " #{@value} ".colorize(:yellow) # values 3 and up default to cyan
    end
  end

end
