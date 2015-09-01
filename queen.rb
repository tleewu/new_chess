require_relative "board"
require_relative "slideable"


class Queen < Piece
  include Slideable

  def initialize(board,position,color)
    mark = color == :white ? " " + "\u2655".encode + " " : " " + "\u265B".encode + " "
    super(board, position, mark, color)
  end

  def moves

    possible_moves = []

    straight_lines = diagonal(@position)
    straight_lines.each do |new_pos|
      next if new_pos == @position
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
          if @board.piece_at_position(step).color == @board.other_color(@color)
            possible_moves << step unless possible_moves.include?(step)
          end
        else
          possible_moves << step
        end
      end
    end

    straight_lines = horizontal(@position)
    straight_lines.each do |new_pos|
      next if new_pos == @position
      seen_piece = false
      dx = new_pos[0] - @position[0]
      dy = new_pos[1] - @position[1]
      if dx.zero?
        dir = [0, dy / dy.abs]
      else
        dir = [dx / dx.abs, 0]
      end
      (1..[dx.abs, dy.abs].max).each do |multiplier|
        break if seen_piece
        change = dir.map { |e| e * multiplier }
        step = [change[0] + @position[0] , change[1] + @position[1]]
        if @board.piece_exist?(step)
          seen_piece = true
          if @board.piece_at_position(step).color == @board.other_color(@color)
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
