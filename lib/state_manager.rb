class StateManager

  def initialize(request, response, move)
      @request = request
      @response = response
      @move = move
  end

  def set_cookies
    @response.set_cookie(@move, "x")
    board_state = Helpers.add_hashes(@request.cookies,{@move => "x"})
    @game_info = Helpers.call_ai(AI.new, {"board"=> board_state}) 
    comp_move = Helpers.ai_move(@game_info)
    @response.set_cookie(comp_move, "o")
    set_winner_if_exists  
  end

  private
  def set_winner_if_exists
    if @game_info.include?("winner")
      @response.set_cookie("winner", @game_info["winner"])
    end
  end

end
