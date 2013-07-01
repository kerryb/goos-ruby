require "sniper_state"

{
  SniperState::JOINING => "Joining",
  SniperState::BIDDING => "Bidding",
  SniperState::WINNING => "Winning",
  SniperState::LOST => "Lost",
  SniperState::WON => "Won",
}.each do |state, label|
  describe state.name do
    specify "translates as '#{label}'" do
      expect(state.to_s).to eq label
    end
  end
end

{
  SniperState::JOINING => SniperState::LOST,
  SniperState::BIDDING => SniperState::LOST,
  SniperState::WINNING => SniperState::WON,
}.each do |state, state_after_close|
  describe state.name do
    specify "transitions to #{state_after_close.inspect} when auction closes" do
      expect(state.when_auction_closed).to be state_after_close
    end
  end
end

[
  SniperState::LOST,
  SniperState::WON,
].each do |state|
  describe state.name do
    specify "does not have a next state" do
      expect { state.when_auction_closed }.to raise_error Defect
    end
  end
end
