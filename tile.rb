class Tile

  def initialize(value)
    @value = value
    @hidden = true
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

end
