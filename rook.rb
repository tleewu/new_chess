require_relative "board"
require_relative "slideable"


class Rook < Piece
  include Slideable

  def initialize(position, board)
    @mark = " R "
    @position = position
    @board = board
  end

  def moves
    horizontal(@position)
  end

  def valid_move?(new_pos)
    return false unless moves.include?(new_pos)
    dx = new_pos[0] - @position[0]
    dy = new_pos[1] - @position[1]
    if dx.zero?
      dir = [0, dy / dy.abs]
    else
      dir = [dx / dx.abs, 0]
    end
    (1...[dx.abs, dy.abs].max).each do |multiplier|
      change = dir.map { |e| e * multiplier }
      step = [change[0] + @position[0] , change[1] + @position[1]]
      return false if @board.piece_exist?(step)
      # TODO ADD KILLING OPPOSITE COLOR PIECE BY LOOKING INTO LAST TILE
    end

    true
  end

end
