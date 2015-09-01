class EmptyPiece < Piece

  def initialize(board, position, color = :no_color)
    super(board, position, "   ", :no_color)
  end

end
