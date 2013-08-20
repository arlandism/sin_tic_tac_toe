
Feature: Select difficulty
  In order to play against a chosen computer difficulty
  As a user
  I should be able to select a difficulty

  Scenario: Choosing a difficulty
    Given I visit the configuration page
    When I choose a Hard AI and play good moves
    Then The AI should tie

    Given I visit the configuration page again
    When I choose an Easy AI and play good moves
    Then I should win
