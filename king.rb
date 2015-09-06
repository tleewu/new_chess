class King < Piece

  POSSIBLE_CHANGES = [[0,1], [1,1],[1,0], [1,-1], [0,-1], [-1,-1], [-1,0], [-1,1]]
  
  attr_reader :can_castle
  
  def initialize(board,position,color)
    mark = color == :white ? " " + "\u2654".encode + " " : " " + "\u265A".encode + " "
    super(board, position, mark, color)
    @can_castle = true
  end

  def moves
    
    possible_moves = []
    x, y = @position
    
    POSSIBLE_CHANGES.each do |change|
      update_position = [change[0] + x, change[1] + y]
      if @board.piece_exist?(update_position)
        if @board.piece_at_position(update_position).color == other_color(@color)
          possible_moves << update_position
        end
      elsif @board.in_bounds?(update_position)
        possible_moves << update_position
      end
    end
    
    #Castling feature
    if @can_castle 
      #King side
      rook = @board.piece_at_position([@position[0], 0])
      if rook.is_a?(Rook) && rook.can_castle 
      #Making sure there is a rook there and that the rook can still castle
        castle_positions = [[@position[0],1], [@position[0],2]]
        #Checking to make sure there are no pieces
        if castle_positions.all? {|pos| @board.piece_at_position(pos).is_a?(EmptyPiece) && !in_check?(pos)}
          possible_moves << [@position[0],1]
        end
      end
      
      rook_queen = @board.piece_at_position([@position[0], 7])
      if rook_queen.is_a?(Rook) && rook_queen.can_castle 
      #Making sure there is a rook there and that the rook can still castle
        castle_positions = [[@position[0],4], [@position[0],5], [@position[0],6] ]
        #Checking to make sure there are no pieces
        if castle_positions.all? {|pos| @board.piece_at_position(pos).is_a?(EmptyPiece) && !in_check?(pos)}
          possible_moves << [@position[0],5]
        end
      end
    end

    possible_moves
  end

  def valid_move?(pos)
    moves.include?(pos)
  end
  
  def update_pos(new_pos, upgrade = false)
    #for king side castle only
    if @can_castle
      if new_pos[1] == 1
        rook = @board.piece_at_position([@position[0],0])
        @board.move_rook_castling(rook,[@position[0],0],[@position[0],2])
      elsif new_pos[1] == 5 #Queen side
        rook = @board.piece_at_position([@position[0],7])
        @board.move_rook_castling(rook,[@position[0],7],[@position[0],4])
      end
    end
    @position = new_pos
    @can_castle = false
  end

end
