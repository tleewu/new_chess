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

  attr_reader :captured_white, :captured_black

  def initialize(new_game = true, grid = nil)
    if new_game
      @grid = populate
      @captured_white = []
      @captured_black = []
      @current_color = :white
    else
      @grid = grid
    end
  end

  def populate
    pop_grid = Array.new(8){Array.new(8)}
    pop_grid.each_with_index do |row,row_idx|
      row.each_with_index do |el, col_idx|
        pop_grid[row_idx][col_idx] = EmptyPiece.new(self,[row_idx,col_idx])
      end
    end
    # pop_grid[7][7] = Piece.new(" X ",[7,7])

    pop_grid[0][0] = Rook.new(self, [0,0], :black)
    pop_grid[0][1] = Knight.new(self, [0,1], :black)
    pop_grid[0][2] = Bishop.new(self, [0,2], :black)
    pop_grid[0][3] = King.new(self, [0,3], :black)
    pop_grid[0][4] = Queen.new(self, [0,4], :black)
    pop_grid[0][5] = Bishop.new(self, [0,5], :black)
    pop_grid[0][6] = Knight.new(self, [0,6], :black)
    pop_grid[0][7] = Rook.new(self, [0,7], :black)

    pop_grid[1][0] = Pawn.new(self, [1,0], :black)
    pop_grid[1][1] = Pawn.new(self, [1,1], :black)
    pop_grid[1][2] = Pawn.new(self, [1,2], :black)
    pop_grid[1][3] = Pawn.new(self, [1,3], :black)
    pop_grid[1][4] = Pawn.new(self, [1,4], :black)
    pop_grid[1][5] = Pawn.new(self, [1,5], :black)
    pop_grid[1][6] = Pawn.new(self, [1,6], :black)
    pop_grid[1][7] = Pawn.new(self, [1,7], :black)

    pop_grid[7][0] = Rook.new(self, [7,0], :white)
    pop_grid[7][1] = Knight.new(self, [7,1], :white)
    pop_grid[7][2] = Bishop.new(self, [7,2], :white)
    pop_grid[7][3] = King.new(self, [7,3], :white)
    pop_grid[7][4] = Queen.new(self, [7,4], :white)
    pop_grid[7][5] = Bishop.new(self, [7,5], :white)
    pop_grid[7][6] = Knight.new(self, [7,6], :white)
    pop_grid[7][7] = Rook.new(self, [7,7], :white)

    pop_grid[6][0] = Pawn.new(self, [6,0], :white)
    pop_grid[6][1] = Pawn.new(self, [6,1], :white)
    pop_grid[6][2] = Pawn.new(self, [6,2], :white)
    pop_grid[6][3] = Pawn.new(self, [6,3], :white)
    pop_grid[6][4] = Pawn.new(self, [6,4], :white)
    pop_grid[6][5] = Pawn.new(self, [6,5], :white)
    pop_grid[6][6] = Pawn.new(self, [6,6], :white)
    pop_grid[6][7] = Pawn.new(self, [6,7], :white)
    pop_grid
  end

  def move(start,end_pos)
    raise NoPieceError unless piece_exist?(start)
    move_piece = @grid[start[0]][start[1]]
    raise WrongColorError unless move_piece.color == @current_color
    raise CantMoveIntoCheckError if move_piece.in_check?(end_pos)
    self.valid_move?(move_piece, start, end_pos)

    @grid[start[0]][start[1]] = EmptyPiece.new(self,[start[0],start[1]])
    if piece_exist?(end_pos)

      captured = piece_at_position(end_pos)
      captured.color == :white ? @captured_white << captured.mark : @captured_black << captured.mark

    end
    @grid[end_pos[0]][end_pos[1]] = move_piece
    move_piece.update_pos(end_pos, true)
  end

  def swap_color
    @current_color = other_color(@current_color)
  end

  def move!(start,end_pos)
    raise NoPieceError unless piece_exist?(start)
    move_piece = @grid[start[0]][start[1]]
    @grid[start[0]][start[1]] = EmptyPiece.new(self,[start[0],start[1]])
    @grid[end_pos[0]][end_pos[1]] = move_piece
    move_piece.update_pos(end_pos)
  end

  def dup
    new_grid = Array.new(8){Array.new(8)}
    new_board = self.class.new(false, new_grid)
    @grid.each_with_index do |row, i|
      row.each_with_index do |el, j|
        new_grid[i][j] = el.class.new(new_board, [i, j], el.color)
      end
    end

    new_board
  end

  def check?(color)
    king_position = find_king(color)
    other_color = other_color(color)
    @grid.flatten.any? do |el|
      el.color == other_color && el.valid_move?(king_position)
    end
  end

  def other_color(color)
    if color == :white
      return :black
    else
      return :white
    end
  end

  def find_king(color)
    pieces(color).each do |piece|
      return piece.position if piece.is_a?(King)
    end
    return "Error finding king..."
  end

  def valid_move?(piece, start, end_pos)
    raise InvalidMoveError if start == end_pos
    unless piece.valid_move?(end_pos)
      raise InvalidMoveError
    end
  end

  def piece_exist?(pos)
    return false unless in_bounds?(pos)
    @grid[pos[0]][pos[1]].class != EmptyPiece
  end

  def piece_at_position(pos)
    @grid[pos[0]][pos[1]]
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
    pos.all? { |x| (0..7).include?(x) }
  end

  def pieces(color)
    @grid.flatten.select {|piece| piece.color == color}
  end

  def checkmate?(color)
    return false unless check?(color)
    pieces(color).all? do |piece|
      piece.moves.all? do |move|
        piece.in_check?(move)
      end
    end
  end

end

class NoPieceError < StandardError
end

class InvalidMoveError < StandardError
end

class CantMoveIntoCheckError < StandardError
end

class WrongColorError < StandardError
end
