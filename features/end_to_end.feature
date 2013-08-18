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

  Scenario: Place a bid and win
    Given an auction of an item is in progress
    When I start bidding in the auction
    And I am told the current price, bid increment and high bidder
    Then I should place a higher bid
    When I am told that I am the high bidder
    And the auction closes
    Then I should have won the auction

  Scenario: Bid for multiple items
    Given auctions of two items are in progress
    When I bid in both auctions
    Then I should win both items

  Scenario: Lose an auction because bids go over my stop price
    Given an auction of an item is in progress
    When I start bidding in the auction, specifying a stop price
    And other bidders push the auction over my stop price
    And the auction closes
    Then I should have lost the auction

  @wip
  Scenario: Abandon and report failure after invalid auction message
    Given auctions of two items are in progress
    When I bid in both auctions
    And I receive an invalid event from one auction
    Then that auction should be shown as failed
    When I receive further events from both auctions
    Then I should bid on the second item as normal
    And the message from the failed auction should be logged
    And the first auction should still be shown as failed
