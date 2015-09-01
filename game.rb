require_relative "board"
require_relative "display"

class Game
  def initialize
    @board = Board.new
    @display = Display.new(@board)
  end

  def run
    until @board.checkmate?(:white) || @board.checkmate?(:black)
      take_turn
    end
    @display.render
    puts "Game over!"
  end

  private

  def take_turn
    begin
      start_pos = @display.move
      end_pos = @display.move
      @board.move(start_pos, end_pos)
    rescue NoPieceError
      puts "There's no piece there, try again!"
      sleep(1)
      retry
    rescue CantMoveIntoCheckError
      puts "You can't move yourself into check, try again!"
      sleep(1)
      retry
    rescue InvalidMoveError
      puts "Invalid move, try again!"
      sleep(1)
      retry
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.run
end
