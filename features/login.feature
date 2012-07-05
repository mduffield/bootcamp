Feature: Login
	In order to use the system, I need to be able to login 	

	Scenario Outline: Login
		Given  I am logged in using "<username>" and "<password>"
		And then visit "/"
		Then I should see "<output>" 

	Examples:
	| username | password |     output    |
	|   admin  |  admin   | Welcome admin |
	|   user   |   user   | Welcome user  |
