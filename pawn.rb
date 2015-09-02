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
    # Need to split up into attack moves and forward moves
    x,y = @position
    possible_moves = []
    if @color == :white
      attack_one = [x-1,y+1]
      attack_two = [x-1,y-1]

      if @board.piece_exist?(attack_one) && @board.piece_at_position(attack_one).color == :black
        possible_moves << attack_one
      end

      if @board.piece_exist?(attack_two) && @board.piece_at_position(attack_two).color == :black
        possible_moves << attack_two
      end

      if @moved
        unless @board.piece_exist?([x - 1, y])
          possible_moves << [x-1,y]
        end
      else
        unless @board.piece_exist?([x - 1, y])
          possible_moves << [x - 1, y]
          unless @board.piece_exist?([x - 2, y])
            possible_moves << [x - 2, y]
          end
        end
      end
    else
      attack_one = [x+1,y+1]
      attack_two = [x+1,y-1]

      if @board.piece_exist?(attack_one) && @board.piece_at_position(attack_one).color == :white
        possible_moves << attack_one
      end

      if @board.piece_exist?(attack_two) && @board.piece_at_position(attack_two).color == :white
        possible_moves << attack_two
      end

      if @moved
        unless @board.piece_exist?([x + 1, y])
          possible_moves << [x+1,y]
        end
      else
        unless @board.piece_exist?([x + 1, y])
          possible_moves << [x + 1, y]
          unless @board.piece_exist?([x + 2, y])
            possible_moves << [x + 2, y]
          end
        end
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
