class Tile

  attr_accessor :value

  def initialize(value)
    @value = value
    @hidden = false
    @flagged = false
  end

  def reveal
    @hidden = false
  end

  def has_bomb?
    @value == "B"
  end

  def flag
    @flagged = true if @hidden && !@flagged
  end

  def to_s
    return "\u2691".encode('utf-8') if @flagged
    return "*" if @hidden
    @value == 0 ? "_" : @value
  end

end
