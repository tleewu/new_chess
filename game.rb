require_relative "board"
require_relative "display"

class Game
  def initialize
    @board = Board.new
    @display = Display.new(@board)
  end

  def run
    while true
      take_turn
    end
    puts "Hooray, the board is filled!"
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
