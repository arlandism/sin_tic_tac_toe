Given(/^I play a game$/) do
    visit '/config'
    choose 'first_player_human'
    choose 'second_player_computer'
    click_button 'submit'
    visit '/'
    click_button '1'
end

When (/^I navigate to the game index$/) do
  visit '/games'
end

Then(/^My game should appear$/) do
   id = Capybara.current_session.driver.request.cookies["id"]
   my_game = page.find_by_id(id)
   my_game.should have_content("x moved to 1")
end 
