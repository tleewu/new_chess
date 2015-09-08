require_relative "board"
require_relative "display"
require_relative "player"
require_relative "humanplayer"
require_relative "computerplayer"

class Game
  def initialize
    @board = Board.new
    @display = Display.new(@board)
    @human = HumanPlayer.new(@board, @display)
    @computer = ComputerPlayer.new(@board)
    @current_player = @human
  end

  def run
    until @board.checkmate?(:white) || @board.checkmate?(:black)
      @current_player.move
      swap_player
    end
    @display.render
    puts "Checkmate! Game over!"
  end

  private
  
  def swap_player
    if @current_player == @human
      @current_player = @computer
    else
      @current_player = @human
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
