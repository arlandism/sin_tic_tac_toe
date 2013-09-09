class GameRecord

  attr_accessor :id, :moves

  def initialize(id)
    @id = id
    @moves = Array.new
  end

  def move_at(space)
    @moves[space -1]
  end

  def set_move(space,token)
    @moves[space - 1] = token
  end

end
