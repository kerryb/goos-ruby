require "support/roles/sniper_listener"
require "main"

describe Main do
  subject { Main.new "item-123" }
  it_behaves_like "a sniper listener"
end
