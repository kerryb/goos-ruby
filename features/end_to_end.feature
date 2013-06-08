Feature: End-to-end test

  Scenario: Lose auction by not bidding
    Join auction, don't bid, and lose when auction closes

    Given an auction of an item is in progress
    When I start bidding in the auction
    And the auction closes
    Then I should have lost the auction
