require_relative "board"
require_relative "slideable"


class Bishop < Piece
  include Slideable

  def initialize(board,position,color)
    mark = color == :white ? " " + "\u2657".encode + " " : " " + "\u265D".encode + " "
    super(board, position, mark, color)
  end

  def moves
    straight_lines = diagonal(@position)
    possible_moves = []

    straight_lines.each do |new_pos|
      seen_piece = false

      dx = new_pos[0] - @position[0]
      dy = new_pos[1] - @position[1]
      dir = [dx / dx.abs, dy / dy.abs]
      
      (1..dx.abs).each do |multiplier|
        break if seen_piece
        change = dir.map { |e| e * multiplier }
        
        step = [change[0] + @position[0] , change[1] + @position[1]]
        
        if @board.piece_exist?(step)
          seen_piece = true
          if @board.piece_at_position(step).color == other_color(@color)
            possible_moves << step unless possible_moves.include?(step)
          end
        else
          possible_moves << step
        end
      end
    end

    possible_moves
  end

  def valid_move?(new_pos)
    moves.include?(new_pos)
  end

end
