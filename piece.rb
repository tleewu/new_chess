class Piece

  def initialize(mark, position)
    @mark = mark
    @position = position
  end

  def to_s
    @mark
  end

  def valid_move?(new_pos)
    "WRITE"
  end

  def update_pos(new_pos)
    @position = new_pos
  end

  def moves
    "WRITE"
  end
end
