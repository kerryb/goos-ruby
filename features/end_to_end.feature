Feature: End-to-end test

  Scenario: Lose auction by not bidding
    Join auction, don't bid, and lose when auction closes

    Given an auction of an item is in progress
    When I start bidding in the auction
    And the auction closes
    Then I should have lost the auction

  Scenario: Place a bid, but still lose
    Given an auction of an item is in progress
    When I start bidding in the auction
    And I am told the current price, bid increment and high bidder
    Then I should place a higher bid
    When the auction closes
    Then I should have lost the auction
