require_relative "board"
require_relative "display"
require_relative "player"
require_relative "humanplayer"
require_relative "computerplayer"

class Game
  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @player1 = HumanPlayer.new(@board, :white, @display)
    @current_player = @player1
  end

  def run
    until (@player2)
      puts "Press C to play computer or H to play against another human, and then press Enter."
      case (gets.chomp[0].downcase)
      when "c"
        @player2 = ComputerPlayer.new(@board)
      when "h"
        @player2 = HumanPlayer.new(@board, :black, @display)
      end
    end

    until @board.checkmate?(:white) || @board.checkmate?(:black)
      @current_player.move
      swap_player
    end
    @display.render
    puts "Checkmate! Game over!"
  end

  private

  def swap_player
    if @current_player == @player1
      @current_player = @player2
    else
      @current_player = @player1
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
