require_relative "board"
require_relative "display"

class HumanPlayer < Player
  def initialize(board, display)
    super(board,:white)
    @display = display
  end
  
  def move
    @display.reset
    start_pos = @display.move
    @display.show_options(start_pos)
    end_pos = @display.move
    @board.move(start_pos, end_pos)
    @display.reset
    @board.swap_color
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
    rescue CannotCastleInCheckError
      puts "You cannot castle when you are in check, try again!"
      sleep(1)
      retry
    rescue WrongColorError
      puts "It's not your turn! Hand over the keyboard!"
      sleep(1)
      retry
  end
  

end