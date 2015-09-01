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
    pop_grid[7][6] = Bishop.new(self, [7,6], :white)
    pop_grid[4][5] = Pawn.new(self, [4,5], :black)
    pop_grid[1][2] = King.new(self, [1,2], :black)
    pop_grid[7][2] = King.new(self, [7,2], :white)

    pop_grid
  end

  def move(start,end_pos)
    raise NoPieceError unless piece_exist?(start)
    move_piece = @grid[start[0]][start[1]]
    self.valid_move?(move_piece, start, end_pos)

    @grid[start[0]][start[1]] = EmptyPiece.new(self,[start[0],start[1]])
    if piece_exist?(end_pos)

      captured = piece_at_position(end_pos)
      captured.color == :white ? @captured_white << captured.mark : @captured_black << captured.mark

    end
    @grid[end_pos[0]][end_pos[1]] = move_piece
    move_piece.update_pos(end_pos)
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
    @grid.each_with_index do |row, i|
      row.each_with_index do |el, j|
        new_grid[i][j] = el.dup
      end
    end

    return self.new(false, new_grid)
  end

  def check?(color)
    king_position = find_king(color)
    other_color = other_color(color)
    @grid.each_with_index do |row, i|
      row.each_with_index do |el, j|
        if el.color == other_color
          return true if el.valid_move?(king_position)
        end
      end
    end

    false
  end

  def other_color(color)
    if color == :white
      return :black
    else
      return :white
    end
  end

  def find_king(color)
    @grid.each_with_index do |row, i|
      row.each_with_index do |el, j|
        return [i, j] if el.is_a?(King) && el.color == color
      end
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
    pos.all? { |x| x.between?(0, 7) }
  end
end

class NoPieceError < StandardError
end

class InvalidMoveError < StandardError
end
