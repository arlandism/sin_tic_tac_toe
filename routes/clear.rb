class TTTDuet < Sinatra::Base

  get '/clear' do
    delete_non_configuration_cookies!
    redirect '/'
  end

  def configuration_setting?(setting_name)
    configurations = ["first_player", "second_player", "depth"]
    configurations.include?(setting_name)
  end
  
  def delete_non_configuration_cookies!
    cookies.each_key do |cookie| 
      response.delete_cookie(cookie) unless configuration_setting?(cookie) 
    end
  end

end
