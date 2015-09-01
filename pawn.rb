class Pawn < Piece

  def initialize(position, board)
    @mark = " P "
    @position = position
    @moved = false
    @board = board
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
    moves.include?(pos)
  end

end
