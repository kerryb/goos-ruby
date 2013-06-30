require "sniper_state"

describe SniperState do

  describe "::JOINING" do
    subject { SniperState::JOINING }
    specify "translates as 'Joining'" do
      expect(subject.to_s).to eq "Joining"
    end

    specify "transitions to LOST when auction closes" do
      expect(subject.when_auction_closed).to be SniperState::LOST
    end
  end

  describe "::BIDDING" do
    subject { SniperState::BIDDING }
    specify "translates as 'Bidding'" do
      expect(subject.to_s).to eq "Bidding"
    end

    specify "transitions to LOST when auction closes" do
      expect(subject.when_auction_closed).to be SniperState::LOST
    end
  end

  describe "::WINNING" do
    subject { SniperState::WINNING }
    specify "translates as 'Winning'" do
      expect(subject.to_s).to eq "Winning"
    end

    specify "transitions to WON when auction closes" do
      expect(subject.when_auction_closed).to be SniperState::WON
    end
  end

  describe "::LOST" do
    subject { SniperState::LOST }
    specify "translates as 'Lost'" do
      expect(subject.to_s).to eq "Lost"
    end

    specify "does not have a next state" do
      expect { subject.when_auction_closed }.to raise_error Defect
    end
  end

  describe "::WON" do
    subject { SniperState::WON }
    specify "translates as 'Won'" do
      expect(subject.to_s).to eq "Won"
    end

    specify "does not have a next state" do
      expect { subject.when_auction_closed }.to raise_error Defect
    end
  end
end
