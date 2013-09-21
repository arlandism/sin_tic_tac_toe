Feature: View Game
  As a user
  I should be able to view a specific game

  Scenario: Viewing The Game
    Given I play a new game
    When I navigate to the game/my_game_id page
    Then I should see my game
