class Knight < Piece

  POSSIBLE_CHANGES = [[1, 2], [2, 1], [-1, 2], [-2, -1],
                      [-2, 1], [1, -2], [2, -1], [-1, -2]]

  def initialize(board,position,color)
    mark = color == :white ? " " + "\u2658".encode + " " : " " + "\u265E".encode + " "
    super(board, position, mark, color)
  end

  def moves
    possible_moves = []
    x, y = @position
    POSSIBLE_CHANGES.each do |change|
      update_position = [change[0] + x, change[1] + y]
      if @board.piece_exist?(update_position)
        if @board.piece_at_position(update_position).color == other_color(@color)
          possible_moves << update_position
        end
      elsif @board.in_bounds?(update_position)
        possible_moves << update_position
      end
    end

    possible_moves
  end

  def valid_move?(pos)
    moves.include?(pos)
  end

end
