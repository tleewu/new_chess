class Piece

  attr_reader :color, :mark, :position

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

  def in_check?(pot_pos)
    dup_board = @board.dup
    dup_board.move!(@position, pot_pos)
    dup_board.check?(@color)
  end

  def other_color(color)
    if color == :white
      return :black
    else
      return :white
    end
  end
end
