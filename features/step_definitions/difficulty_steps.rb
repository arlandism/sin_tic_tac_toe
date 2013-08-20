Given(/^I visit the configuration page$/) do
  visit '/config'
end

When(/^I choose a Hard AI and play good moves$/) do
  choose 'hard'
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

When(/^I choose an Easy AI and play good moves$/) do
  choose 'hard'
  click_button '1'
  click_button '9'
  click_button '2'
  click_button '7'
  click_button '6'
end

Then(/^I should win$/) do
  page.should have_content("x wins")
end
