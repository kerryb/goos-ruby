require "announcer"

describe Announcer do
  let(:listener_1) { double :listener_1, event_a: true, event_b: true }
  let(:listener_2) { double :listener_2, event_a: true, event_b: true }
  before do
    subject.add_listener listener_1
    subject.add_listener listener_2
  end

  it "announces to registered listeners" do
    subject.event_a
    subject.event_b

    expect(listener_1).to have_received :event_a
    expect(listener_2).to have_received :event_a
    expect(listener_1).to have_received :event_b
    expect(listener_2).to have_received :event_b
  end

  it "passes event arguments to listeners" do
    subject.event_a "foo", 42
    expect(listener_1).to have_received(:event_a).with "foo", 42
  end

  it "can remove listeners" do
    subject.remove_listener listener_1
    subject.event_a

    expect(listener_1).to_not have_received :event_a
    expect(listener_2).to have_received :event_a
  end
end
