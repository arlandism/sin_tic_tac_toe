require 'json'

Given(/^I play a game$/) do
    visit '/config'
    choose 'first_player_human'
    choose 'second_player_computer'
    click_button 'submit'
    visit '/'
    click_button '1'
end

Then(/^That game's history should be recorded$/) do
   id = Capybara.current_session.driver.request.cookies["id"]
   games = JSON.parse(File.read("game_history.json")) 
   games["games"][id.to_s]["moves"][0]
   first_move = games["games"][id.to_s]["moves"][0]
   first_move["position"].should == 1
   first_move["token"].should == "x" 
end
