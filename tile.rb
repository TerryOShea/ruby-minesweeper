class Tile

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

  def to_s
    return "\u2691".encode('utf-8') if @flagged
    return "*" if @hidden
    @value == 0 ? "_" : @value
  end

end
