require_relative "display.rb"
require_relative "cursorable.rb"
require_relative "piece"
require_relative "empty_piece"
require_relative "bishop"
require_relative "rook"
require_relative "queen"
require_relative "king"
require_relative "knight"
require_relative "pawn"

class Board

  def initialize
    @grid = populate
  end

  def populate
    pop_grid = Array.new(8){Array.new(8)}
    pop_grid.each_with_index do |row,row_idx|
      row.each_with_index do |el, col_idx|
        pop_grid[row_idx][col_idx] = EmptyPiece.new([row_idx,col_idx])
      end
    end
    # pop_grid[7][7] = Piece.new(" X ",[7,7])
    pop_grid[7][6] = Bishop.new([7,6], self)
    pop_grid[4][5] = Rook.new([4,5], self)
    pop_grid
  end

  def move(start,end_pos)
    raise NoPieceError unless piece_exist?(start)
    move_piece = @grid[start[0]][start[1]]
    self.valid_move?(move_piece, start, end_pos)

    @grid[start[0]][start[1]] = EmptyPiece.new([start[0],start[1]])
    @grid[end_pos[0]][end_pos[1]] = move_piece
    move_piece.update_pos(end_pos)
  end

  def valid_move?(piece, start, end_pos)
    unless piece.valid_move?(end_pos)
      raise InvalidMoveError
    end
    unless @grid[end_pos[0]][end_pos[1]].class == EmptyPiece #No piece can move onto another piece
      #TODO: add functionality with colored pieces
      raise InvalidMoveError
    end
  end

  def piece_exist?(pos)
    @grid[pos[0]][pos[1]].class != EmptyPiece
  end

  def [](pos)
    row,col = pos
    @grid[row][col]
  end

  def []=(pos, piece)
    row,col = pos
    @grid[row][col] = piece
  end

  def rows
    @grid
  end

  def in_bounds?(pos)
    pos.all? { |x| x.between?(0, 7) }
  end
end

class NoPieceError < StandardError
end

class InvalidMoveError < StandardError
end
