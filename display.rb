require "colorize"
require_relative "cursorable"

class Display
  include Cursorable

  def initialize(board)
    @board = board
    @cursor_pos = [0, 0]
    @highlights = []
  end

  def build_grid
    @board.rows.map.with_index do |row, i|
      build_row(row, i)
    end
  end

  def build_row(row, i)
    row.map.with_index do |piece, j|
      color_options = colors_for(i, j)
      piece.to_s.colorize(color_options)
    end
  end

  def colors_for(i, j)
    if [i, j] == @cursor_pos
      bg = :light_red
    elsif @highlights.include?([i,j])
      bg = :yellow
    elsif (i + j).odd?
      bg = :light_blue
    else
      bg = :green
    end
    { background: bg, color: @board.piece_at_position([i,j]).color }
  end

  def show_options(pos)
    piece = @board.piece_at_position(pos)
    moves = piece.moves
    moves = moves.reject {|move| piece.in_check?(move)}
    @highlights = moves
    render
  end

  def reset
    @highlights = []
  end

  def render

    system("clear")
    puts "Arrow keys to move, space or enter to confirm."
    puts "   " + ("A".."H").to_a.join("  ") + "   " + @board.captured_white.join("")
    build_grid.each_with_index { |row,row_idx| puts "#{row_idx} " + row.join + " #{row_idx}" }
    puts "   " + ("A".."H").to_a.join("  ") + "   " + @board.captured_black.join(" ")
    if @board.check?(:white)
      puts "White is in check!"
    elsif @board.check?(:black)
      puts "Black is in check!"
    end
  end

  def move
    result = nil
    until result
      render
      result = get_input
    end
    result
  end
end
