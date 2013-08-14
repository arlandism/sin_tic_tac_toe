
Feature: Perform the simplest use case: Human Vs. Impossible AI
  In order to play a game of Tic Tac Toe
  As a human
  I should be able to play and move first against an Impossible AI

  Scenario: Playing against Impossible AI
    Given I visit the home page
    When I play a game against an Impossible AI 
    Then The Impossible AI should win or tie 
    And No further moves should be possible 
