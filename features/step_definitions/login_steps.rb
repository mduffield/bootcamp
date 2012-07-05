Given /^I am logged in using "(.*?)" and "(.*?)"$/ do |username, password|
	visit('/login/form')
	fill_in "username", :with => username 
	fill_in "password", :with => password 
	click_button("log in")
end

Given /^then visit "(.*?)"$/ do |url|
        visit(url)
end

Then /^I should see "(.*?)"$/ do |arg1|
	response.body.should contain(arg1)
end


