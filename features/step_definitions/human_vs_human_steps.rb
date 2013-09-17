Given(/^I go to the configuration page$/) do
    visit '/clear'
    visit '/config'
end

When(/^I select a Human as the first player and another human as the second$/) do
  choose 'first_player_human'
  choose 'second_player_human'
  click_button 'submit'
end

Then(/^We should be able to play against one another$/) do
  pending
  #click_button '1'
  #click_button '2'
  #find_by_id(1)[:value].should == "x" 
  #find_by_id(2)[:value].should == "o" 
end
