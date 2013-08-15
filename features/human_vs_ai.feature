
Feature: Perform the simplest use case: Human Vs. Impossible AI
  In order to play a game of Tic Tac Toe
  As a human
  I should be able to play and move first against an Impossible AI

  Scenario: Playing against Impossible AI
    Given I visit the home page
    When I play a sequence of bad moves against an Impossible AI 
    Then The Impossible AI should win 
    
    Given I visit the home page again
    When I play a sequence of good moves against an Impossible AI 
    Then The Impossible AI should tie and no further moves should be available 
