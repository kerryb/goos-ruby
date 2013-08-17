require "sniper_state"

{
  SniperState::JOINING => [false, "Joining"],
  SniperState::BIDDING => [false, "Bidding"],
  SniperState::LOSING => [false, "Losing"],
  SniperState::WINNING => [true, "Winning"],
  SniperState::LOST => [false, "Lost"],
  SniperState::WON => [true, "Won"],
  SniperState::FAILED => [false, "Failed"],
}.each do |state, (winning, label)|
  describe state.name do
    specify "is #{winning ? '' : 'not '} winning" do
      expect(state.winning?).to eq winning
    end

    specify "translates as '#{label}'" do
      expect(state.to_s).to eq label
    end
  end
end

{
  SniperState::JOINING => SniperState::LOST,
  SniperState::BIDDING => SniperState::LOST,
  SniperState::LOSING => SniperState::LOST,
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
  SniperState::FAILED,
].each do |state|
  describe state.name do
    specify "does not have a next state" do
      expect { state.when_auction_closed }.to raise_error Defect
    end
  end
end
