
Feature: Two Human Players
  When selecting the players
  As a user
  I should be able to play against another human

  Scenario: Selecting two humans from player list
    Given I go to the configuration page
    When I select a Human as the first player and another human as the second
    Then We should be able to play against one another
