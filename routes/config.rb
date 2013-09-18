class TTTDuet < Sinatra::Base

  get '/config' do
    haml :config
  end

   post '/config' do
      difficulty = params[:depth]
      first_player = params[:first_player]
      second_player = params[:second_player]
      response.set_cookie("depth",difficulty)
      response.set_cookie("first_player",first_player)
      response.set_cookie("second_player",second_player)
      redirect '/'
   end

end
