module Slideable
  def diagonal(pos)
    x = pos[0]
    y = pos[1]
    available_moves = []
    (-8..8).each do |i|
      if (0..8).include?(x + i) && (0..8).include?(y + i)
        available_moves << [x + i, y + i]
      end
      if (0..8).include?(x - i) && (0..8).include?(y + i)
        available_moves << [x - i, y + i]
      end
    end

    available_moves
  end

  def horizontal(pos)
    x = pos[0]
    y = pos[1]
    available_moves = []
    (-8..8).each do |i|
      available_moves << [x + i, y] if (0..8).include?(x + i)
      available_moves << [x, y + i] if (0..8).include?(y + i)
    end

    available_moves
  end
end
