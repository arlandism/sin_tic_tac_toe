Given(/^I play a new game$/) do
    visit '/config'
    choose 'first_player_human'
    choose 'second_player_computer'
    click_button 'submit'
    visit '/'
    click_button '1'
end

When(/^I navigate to the game\/my_game_id page$/) do
    my_game_id = Capybara.current_session.driver.request.cookies["id"]
    visit "/games/#{my_game_id}"
end

Then(/^I should see my game$/) do
    page.should have_content("x moved to 1")
end
