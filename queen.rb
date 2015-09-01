require_relative "board"
require_relative "slideable"


class Queen < Piece
  include Slideable

  def initialize(board,position,color)
    mark = color == :white ? " " + "\u2655".encode + " " : " " + "\u265B".encode + " "
    super(board, position, mark, color)
  end

  def moves
    horizontal(@position) + diagonal(@position)
  end

  def valid_move?(new_pos)
    return false unless moves.include?(new_pos)
    took_piece = false
    dx = new_pos[0] - @position[0]
    dy = new_pos[1] - @position[1]
    if dx.zero? || dy.zero?
      if dx.zero?
        dir = [0, dy / dy.abs]
      else
        dir = [dx / dx.abs, 0]
      end
      (1..[dx.abs, dy.abs].max).each do |multiplier|
        return false if took_piece
        change = dir.map { |e| e * multiplier }
        step = [change[0] + @position[0] , change[1] + @position[1]]
        if @board.piece_exist?(step)
          if @board.piece_at_position(step).color == @color
            return false
          elsif @board.piece_at_position(step).color == @board.other_color(@color)
            took_piece = true
          end
        end
      end
    else
      dir = [dx / dx.abs, dy / dy.abs]
      (1..dx.abs).each do |multiplier|
        return false if took_piece
        change = dir.map { |e| e * multiplier }
        step = [change[0] + @position[0] , change[1] + @position[1]]
        if @board.piece_exist?(step)
          if @board.piece_at_position(step).color == @color
            return false
          elsif @board.piece_at_position(step).color == @board.other_color(@color)
            took_piece = true
          end
        end
      end
    end

    true
  end

end
