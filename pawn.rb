class Pawn < Piece

  def initialize(board,position,color)
    mark = color == :white ? " " + "\u2659".encode + " " : " " + "\u265F".encode + " "
    super(board, position, mark, color)
    @moved = false
  end

  def update_pos(new_pos, upgrade = false)
    @position = new_pos
    if new_pos[0] == 0 || new_pos[0] == 7
      upgrade_pawn if upgrade
    end
    @moved = true
  end

  def moves

    x,y = @position
    possible_moves = []
    
    if @color == :white
      attack = [[x-1,y+1],[x-1,y-1]]

      unless @board.piece_exist?([x - 1, y])
        possible_moves << [x-1,y]
        possible_moves << [x-2,y] unless @moved || @board.piece_exist?([x - 2, y])
      end
      
    else
      attack = [[x+1,y+1],[x+1,y-1]]

      unless @board.piece_exist?([x+1, y])
        possible_moves << [x+1,y]
        possible_moves << [x+2,y] unless @moved || @board.piece_exist?([x + 2, y])
      end

    end
    
    attack.each do |attack_pos|
      if @board.piece_exist?(attack_pos) && @board.piece_at_position(attack_pos).color == other_color(@color)
        possible_moves << attack_pos
      end
    end

    possible_moves.select do |pos|
      (0..7).include?(pos[0]) && (0..7).include?(pos[1])
    end
  end

  def valid_move?(pos)
    moves.include?(pos)
  end

  def upgrade_pawn
    puts "Your pawn has made it! What piece would you like?"
    puts "Select N/Knight, B/Bishop, R/Rook, Q/Queen"

    case gets.chomp[0].downcase
    when "n"
      @board[@position] = Knight.new(@board,@position,@color)
    when "b"
      @board[@position] = Bishop.new(@board,@position,@color)
    when "r"
      @board[@position] = Rook.new(@board,@position,@color)
    when "q"
      @board[@position] = Queen.new(@board,@position,@color)
    end
  end
end
