
Feature: Select the first player
  When selecting the first player
  As a human
  I should be able to select AI as first player

  Scenario: Selecting AI as first player
    Given I visit the configuration page to choose first player
    When I select the Computer as the first player and refresh the page
    Then There should be a move already made on the board
