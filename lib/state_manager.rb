require 'helpers'
require 'ai'

class StateManager

  def initialize(request, response, move=nil)
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

  def set_difficulty(difficulty)
    @response.set_cookie("depth",difficulty)
  end

  def clear_cookies
    @request.cookies.keys.each do |key|
      @response.delete_cookie(key)
    end
  end

  private
  def set_winner_if_exists
    @game_info.include?("winner") ? @response.set_cookie("winner", @game_info["winner"]):nil
    end

  end

