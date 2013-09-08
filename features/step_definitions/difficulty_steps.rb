Given(/^I visit the configuration page$/) do
  visit '/config'
end

When(/^I choose a Hard AI and play good moves$/) do
  choose 'hard'
  click_button 'submit'
  click_button '1'
  click_button '9'
  click_button '2'
  click_button '7'
  click_button '6'
end

Then(/^The AI should tie$/) do
  (1..9).each do |num|
      find_by_id(num.to_s)[:disabled].should eq "disabled"
  end
end

Given(/^I visit the configuration page again$/) do
  visit '/clear'
  visit '/config'
end

When(/^I choose an Easy AI as the second player and play dumb moves$/) do
  choose 'Easy'
  choose 'first_player_human'
  choose 'second_player_computer'
  click_button 'submit'
  click_button '1'
  click_button '2'
  click_button '3'
end

Then(/^I should win$/) do
  page.should have_content("x wins")
  teardown
end

def teardown
  visit '/config'
  choose 'Hard'
  choose 'first_player_human'
  choose 'first_player_computer'
  click_button 'submit'
end
