class Piece

  attr_reader :color, :mark

  def initialize(board, position, mark, color)
    @board = board
    @position = position
    @mark = mark
    @color = color
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
