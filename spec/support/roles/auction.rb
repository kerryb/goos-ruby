shared_examples_for "an auction" do
  it "responds to #add_event_listener" do
    expect(subject).to respond_to :add_event_listener
  end

  it "responds to #join" do
    expect(subject).to respond_to :join
  end

  it "responds to #bid" do
    expect(subject).to respond_to :bid
  end
end
