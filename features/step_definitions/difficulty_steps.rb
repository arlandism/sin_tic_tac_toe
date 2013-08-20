Given(/^I visit the configuration page$/) do
  visit '/config'
end

When(/^I choose a Hard AI and play good moves$/) do
  click_button 'hard'
  click_button 'submit'
  play_good_moves
end

Then(/^The AI should tie$/) do
  page.should_not have_content("wins")
    (1..9).each do |num|
      find_by_id(num.to_s)[:disabled].should eq "disabled"
  end
end

Given(/^I visit the configuration page again$/) do
  visit '/clear'
  visit '/config'
end

When(/^I choose an Easy AI and play good moves$/) do
  play_good_moves
end

Then(/^I should win$/) do
  page.should have_content("x wins")
end

def play_good_moves
  click_button '9'
  click_button '2'
  click_button '7'
  click_button '6'
end
