require_relative 'helpers'
require_relative 'ai'

class CookieManager

  def initialize(request,response)
    @request = request
    @response = response
  end

  def set_cookie(key,val)
    @response.set_cookie(key,val)
  end

  def clear_cookies
    @request.cookies.keys.each do |key|
      @response.delete_cookie(key)
    end
  end

end

class StateManager

  def initialize(request, response, move=nil)
      @request = request
      @response = response
      @cookie_manager = CookieManager.new(@request,@response)
      @move = move
  end

  def set_cookies
    @cookie_manager.set_cookie(@move,"x")
    comp_move = extract_data_and_call_ai
    @cookie_manager.set_cookie(comp_move, "o")
    set_winner_if_exists  
  end

  def set_configs(params)
    @response.set_cookie("depth",params[:difficulty])
  end

  def clear_cookies
    @cookie_manager.clear_cookies    
  end

  private

  def extract_data_and_call_ai
    keys = @request.cookies.select{ |key,_| key=~/^[0-9]+$/ } 
    state =  Helpers.add_hashes(keys, {@move => "x"})
    state = insert_depth_if_present({"board" => state})
    @game_info = Helpers.call_ai(AI.new, state) 
    comp_move = Helpers.ai_move(@game_info)
    comp_move
  end

  def insert_depth_if_present(to_merge)
    if @request.cookies["depth"]
      to_merge.merge!({"depth" => @request.cookies["depth"].to_i})
    end
    to_merge
  end

  def set_winner_if_exists
    @game_info.include?("winner") ? @cookie_manager.set_cookie("winner", @game_info["winner"]):nil
    end

  end
