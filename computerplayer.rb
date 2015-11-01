require_relative "board"

class ComputerPlayer < Player
  def initialize(board)
    super(board,:black)
  end

  def move
    @board.move(best_move[0], best_move[1])
    @board.swap_color
  end

  def best_move
    if @board.check?(:black)
      @board.pieces(:black).each do |piece|
        piece.moves.each do |move|
          dup_board = @board.dup
          dup_board.move!(piece.position, move)
          unless (dup_board.check?(:black))
            if piece.is_a?(King)
              move_king_at_last_resort = [piece.position,move]
            else
              return [piece.position,move]
            end
          end
        end
      end


    else
      if can_take_piece.empty?
        move_closest_to_king
      else
        [can_take_piece[:position],can_take_piece[:move]]
      end
    end
  end

  def move_closest_to_king

    king_pos = @board.find_king(:white)
    closest_to = nil
    closest_diff = 0

    @board.pieces(:black).each do |piece|
      piece.moves.each do |move|
        if closest_to.nil?
          closest_to = [piece.position, move]
          closest_diff = (king_pos[0] - move[0]).abs + (king_pos[1] - move[1]).abs
          break
        end
        change = (king_pos[0] - move[0]).abs + (king_pos[1] - move[1]).abs
        if change < closest_diff
          closest_diff = change
          closest_to = [piece.position, move]
        end
      end
    end

    closest_to
  end

  def can_take_piece

    max_point_value = 0
    recorded_move = {}

    @board.pieces(:black).each do |piece|
      piece.moves.each do |move|
        point_value = 0
        current_piece = @board[move]
        unless current_piece.is_a?(EmptyPiece) && current_piece.color == :white
          if current_piece.is_a?(Pawn)
            point_value = 1
          elsif current_piece.is_a?(Knight) || current_piece.is_a?(Bishop)
            point_value = 3
          elsif current_piece.is_a?(Rook)
            point_value = 5
          elsif current_piece.is_a?(Queen)
            point_value = 10
          end

          point_value -= check_if_attacked(piece, move) if check_if_attacked(piece,move).nil?

          if point_value > max_point_value
            max_point_value = point_value
          #updating the hash
            recorded_move = {}
            recorded_move[:piece] = piece
            recorded_move[:position] = piece.position
            recorded_move[:move] = move
          end
        end
      end
    end

    recorded_move
  end

  def check_if_attacked(piece,move)
    if @board.pieces(:white).any? {|mov_piece| mov_piece.valid_move?(move)}
      return 1 if piece.is_a?(Pawn)
      return 3 if piece.is_a?(Knight) || piece.is_a?(Bishop)
      return 5 if piece.is_a?(Rook)
      return 10 if piece.is_a?(Queen)
    else
      return 0
    end
  end

end
