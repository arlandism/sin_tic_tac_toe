Given(/^I go to the configuration page$/) do
    visit '/config'
end

When(/^I select a Human as the first player and another human as the second$/) do
  choose 'first_player_human'
  choose 'second_player_human'
  click_button 'submit'
end

Then(/^We should be able to play against one another$/) do
  click_button '1'
  click_button '2'
  click_button '3'
  click_button '4'
  click_button '5'
  click_button '6'
  click_button '8'
  click_button '7'
  click_button '9'
end
