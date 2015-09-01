class Pawn < Piece

  def initialize(board,position,color)
    mark = color == :white ? " " + "\u2659".encode + " " : " " + "\u265F".encode + " "
    super(board, position, mark, color)
  end

  def moves
    x,y = @position
    if @moved
      [[x-1,y]]
    else
      @moved = true
      @board.piece_exist?([x-1,y]) ? [[x-1,y]] : [[x-1,y],[x-2,y]]
      #Cannot jump over a piece on first move
    end
  end

  def valid_move?(pos)
    if @board.piece_exist?(pos) && @board.piece_at_position(pos).color == @color
      return false
    end
    moves.include?(pos)
  end

end
