Feature: Game History
  As a user
  My game's history should be recorded

  Scenario: Recording Game History
    Given I play a game
    When I navigate to the game index
    Then My game should appear
