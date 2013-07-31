require 'sinatra'
require 'haml'
require_relative 'lib/ai.rb'

  get '/' do
    @board = request.cookies
    haml :index 
  end

  post '/move' do
    move = params[:player_move]
    response.set_cookie(move, "x")
    human_move = {move.to_i => "x"}
    board_state = hash_with_keys_as_ints(request.cookies.merge(human_move))
    computer_move = AI.new.next_move(board_state)
    response.set_cookie(computer_move, "o")
    redirect '/'
  end

  def hash_with_keys_as_ints(hash)
    new_hash = Hash.new
    hash.each do |key, value|
      new_hash[key.to_i] = value
    end
    new_hash
  end

