require 'sinatra'
require 'haml'
require_relative 'lib/winner_presenter'
require_relative 'lib/button_presenter'
require_relative 'lib/ai'

  get '/' do
    @board = request.cookies
    haml :index 
  end

  get '/clear' do
    request.cookies.keys.each do |key|
      response.delete_cookie(key)
    end
    redirect '/'
  end

  post '/move' do
    move = params[:player_move]
    response.set_cookie(move, "x")
    human_move = {move => "x"}
    board_state = add_hashes(request.cookies,human_move)
    computer = AI.new
    game_info = call_ai(computer,board_state) 
    comp_move = ai_move(game_info)
    response.set_cookie(comp_move,"o")
    set_winner_if_exists(response,game_info)
    redirect '/'
  end

  def set_winner_if_exists(response,game_info)
    if game_info.include?("winner")
      response.set_cookie("winner",game_info["winner"])
    end
  end

  def hash_with_keys_as_ints(hash)
    new_hash = Hash.new
    hash.each do |key, value|
      new_hash[key.to_i] = value
    end
    new_hash
  end

  def add_hashes(hash_one,hash_two)
    hash_with_keys_as_ints(hash_one.merge(hash_two))
  end

  def winner(hash)
    hash["winner"]
  end

  def call_ai(ai,hash)
    ai.next_move(hash) 
  end

  def ai_move(hash)
    hash["move"]
  end
