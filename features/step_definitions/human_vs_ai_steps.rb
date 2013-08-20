
Given(/^I visit the home page$/) do
  visit '/'
end

When(/^I play a sequence of bad moves against an Impossible AI$/) do
  click_button '6'
  click_button '3'
  click_button '2'
end

Then(/^The Impossible AI should win$/) do
    page.should have_content("o wins")    
end

Given(/^I visit the home page again$/) do
  visit '/clear'
  visit '/'
end

When(/^I play a sequence of good moves against an Impossible AI$/) do
  click_button '1'
  click_button '9'
  click_button '2'
  click_button '7'
  click_button '6'
end

Then(/^The Impossible AI should tie and no further moves should be available$/) do
    page.should_not have_content("wins")
    (1..9).each do |num|
      find_by_id(num.to_s)[:disabled].should eq "disabled"
    end
end
