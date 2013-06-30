require "support/roles/sniper_listener"
require "ui_thread_sniper_listener"

describe UiThreadSniperListener do
  subject { UiThreadSniperListener.new double(:delegate) }
  it_behaves_like "a sniper listener"
end
