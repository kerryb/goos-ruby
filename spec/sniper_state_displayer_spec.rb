require "support/roles/sniper_listener"
require "sniper_state_displayer"

describe SniperStateDisplayer do
  subject { SniperStateDisplayer.new double(:main_window) }
  it_behaves_like "a sniper listener"
end
