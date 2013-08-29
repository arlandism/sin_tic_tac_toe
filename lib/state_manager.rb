require_relative 'ai'
require_relative 'cookie_manager'

class StateManager

  def initialize(request, response)
    @request = request
    @response = response
    @cookie_manager = CookieManager.new(@request,@response)
  end

  def handle_cookies(params)
    move = params[:player_move]
    @cookie_manager.set_cookie(move,"x")
    ai_move = extract_data_and_call_ai(move)
    @cookie_manager.set_cookie(ai_move, "o")
    set_winner_if_exists  
  end

  def set_configs(params)
    @response.set_cookie("depth",params[:difficulty])
  end

  def clear_cookies
    @cookie_manager.clear_cookies    
  end

  private

  def extract_data_and_call_ai(move)
    state = add_move(moves,move)
    new_state = add_depth_if_present({"board" => state})
    @received = AI.new.next_move(new_state) 
    ai_move = @received["move"]    
    ai_move
  end

  def add_move(old_state,move)
    old_state.merge({move => "x"})
  end

  def moves
    keys = @request.cookies.select{ |key,_| key=~/^[0-9]+$/ } 
  end

  def add_depth_if_present(to_merge)
    depth = @request.cookies["depth"]
    depth ? to_merge.merge!({"depth" => depth.to_i}): nil
    to_merge
  end

  def set_winner_if_exists
    winner = @received["winner"]
    winner ? @cookie_manager.set_cookie("winner", winner):nil
  end

end
