Given(/^I visit the configuration page to choose first player$/) do
  visit '/config'
end

When(/^I select the Computer as the first player$/) do
  choose 'hard'
  choose 'computer'
  click_button 'submit'
end

Then(/^There should be a move already made on the board$/) do
  MOVE_COMP_ALWAYS_PICKS = 9
  find_by_id(MOVE_COMP_ALWAYS_PICKS.to_s )[:disabled].should == "disabled"
end